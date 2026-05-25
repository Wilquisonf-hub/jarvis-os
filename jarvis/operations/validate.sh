#!/bin/bash
# validate.sh -- Validate Jarvis OS integrity
# Usage: bash operations/validate.sh [--fix-secrets]
# Compatible with bash 3.2 (macOS default)
export TERM=${TERM:-xterm-256color}
set +e

JARVIS_OS_ROOT="$(cd "$(dirname "$0")/.." 2>/dev/null && pwd)"
cd "$JARVIS_OS_ROOT"

# Colors via tput for POSIX compatibility
RED=$(tput setaf 1 2>/dev/null || echo -e "\033[0;31m")
GREEN=$(tput setaf 2 2>/dev/null || echo -e "\033[0;32m")
YELLOW=$(tput setaf 3 2>/dev/null || echo -e "\033[1;33m")
BLUE=$(tput setaf 4 2>/dev/null || echo -e "\033[0;34m")
CYAN=$(tput setaf 6 2>/dev/null || echo -e "\033[0;36m")
NC=$(tput sgr0 2>/dev/null || echo -e "\033[0m")

ERRORS=0
WARNINGS=0

pass_msg()
{
    echo "${GREEN}[PASS]${NC} $1"
    ERRORS=$((ERRORS + 0))
}
warn_msg()
{
    echo "${YELLOW}[WARN]${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}
fail_msg()
{
    echo "${RED}[FAIL]${NC} $1"
    ERRORS=$((ERRORS + 1))
}
info_msg()
{
    echo "${BLUE}[INFO]${NC} $1"
}
section_msg()
{
    echo ""
    echo "${CYAN}=== $1 ===${NC}"
}

check_prerequisites()
{
    section_msg "Prerequisites"
    local missing=0
    for dir in identity scripts; do
        if [ -d "$JARVIS_OS_ROOT/$dir" ]; then
            pass_msg "Directory $dir exists"
        else
            fail_msg "Directory $dir missing"
            missing=1
        fi
    done

    if [ "$missing" -ne 0 ]; then
        fail_msg "Prerequisites not met"
        return 1
    fi
    pass_msg "All prerequisites OK"
    return 0
}

check_file_exists()
{
    local file="$1"
    if [ -f "$JARVIS_OS_ROOT/identity/$file" ]; then
        pass_msg "$file exists in identity/"
        return 0
    else
        fail_msg "$file missing from identity/"
        return 1
    fi
}

check_script_exists()
{
    local script="$1"
    if [ -f "$JARVIS_OS_ROOT/$script" ]; then
        pass_msg "$script exists"
        if [ -x "$JARVIS_OS_ROOT/$script" ]; then
            pass_msg "$script is executable"
        else
            warn_msg "$script exists but not executable"
        fi
        return 0
    else
        fail_msg "$script missing"
        return 1
    fi
}

check_secrets()
{
    section_msg "Secrets scan"
    local found=0
    local fix_secrets=false
    if [ "$1" = "--fix-secrets" ]; then
        fix_secrets=true
    fi

    local envfile="$JARVIS_OS_ROOT/.env.example"
    if [ -f "$envfile" ]; then
        pass_msg ".env.example found"
    else
        fail_msg ".env.example not found"
        found=1
    fi

    local secret_patterns=(
        "AWS_ACCESS_KEY_ID"
        "AWS_SECRET_ACCESS_KEY"
        "PRIVATE_KEY"
        "SIGNING_KEY"
        "ENCRYPTION_KEY"
        "PASSWORD"
        "SECRET_KEY"
        "API_KEY"
        "TOKEN"
    )

    local scan_result=""
    for pattern in "${secret_patterns[@]}"; do
        if grep -rl "$pattern" "$JARVIS_OS_ROOT/identity/" 2>/dev/null; then
            scan_result="FOUND"
            found=1
            fail_msg "Potential secret: $pattern found in identity/"
        fi
    done

    if [ -n "$scan_result" ]; then
        if [ "$fix_secrets" = true ]; then
            warn_msg "Fix mode enabled - review files manually"
        fi
    else
        pass_msg "No secrets detected in identity/"
    fi

    FOUND_SECRETS=$found
    return $FOUND_SECRETS
}

check_git()
{
    section_msg "Git status"
    if [ -d "$JARVIS_OS_ROOT/.git" ]; then
        pass_msg ".git directory exists"
    else
        fail_msg "No .git directory"
        return 1
    fi

    local uncommitted
    uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$uncommitted" -gt 0 ]; then
        warn_msg "Uncommitted changes: $uncommitted"
    else
        pass_msg "Working tree clean"
    fi

    local staged
    staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    if [ "$staged" -gt 0 ]; then
        warn_msg "Staged changes: $staged"
    else
        pass_msg "Index clean"
    fi

    local untracked
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    if [ "$untracked" -gt 10 ]; then
        warn_msg "Many untracked files: $untracked"
    fi

    local remotes
    remotes=$(git remote -v 2>/dev/null | grep -c fetch)
    if [ -n "$remotes" ] && [ "$remotes" -gt 0 ]; then
        pass_msg "Remote configured"
    fi
}

check_backup()
{
    section_msg "Backup verification"
    local backup_dir="$JARVIS_OS_ROOT/backups"

    if [ -d "$backup_dir" ]; then
        pass_msg "Backup directory exists"
        local backup_count
        backup_count=$(find "$backup_dir" -name "*.tar.gz" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$backup_count" -gt 0 ]; then
            pass_msg "$backup_count backup(s) found"
        fi
        if [ -f "$backup_dir/MANIFEST.md" ]; then
            pass_msg "Backup manifest exists"
        fi
    else
        warn_msg "No backup directory found"
    fi
}

check_env()
{
    section_msg "Environment files"
    if [ -f "$JARVIS_OS_ROOT/.env.example" ]; then
        pass_msg ".env.example exists"
    fi
    if [ -f "$JARVIS_OS_ROOT/.env" ]; then
        pass_msg ".env exists (development key present)"
    else
        warn_msg ".env not found (expected in development)"
    fi
}

check_deploy_state()
{
    section_msg "Deploy state"
    local deploy_state="$JARVIS_OS_ROOT/.deploy_state.json"
    if [ -f "$deploy_state" ]; then
        pass_msg "Deploy state file exists"
        if grep -q '"deployed"' "$deploy_state" 2>/dev/null; then
            pass_msg "Last deployment successful"
        fi
    fi
}

# ---- Main ----
section_msg "Jarvis OS Validation"

check_prerequisites
check_secrets "$@"
check_git
check_backup
check_env
check_deploy_state

echo ""
section_msg "Summary"
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    pass_msg "System integrity: PASSED ($ERRORS errors, $WARNINGS warnings)"
    exit 0
else
    echo "${RED}[FAIL] System integrity: FAILED ($ERRORS errors)${NC}"
    exit 1
fi
