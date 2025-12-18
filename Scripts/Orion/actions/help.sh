show_help() {
    cat << EOF
${CYAN}${BOLD}Orion - Package Update Manager${RESET}
Version: 2.4

${CYAN}Usage:${RESET}
  orion [OPTION] [PACKAGE]

${CYAN}Options:${RESET}
  -l, --list              List available packages
  -u, --update PACKAGE    Update specific package
  -a, --all               Update all packages
  -y, --yes               Bypass confirmation prompts
  -t, --tarball           Force tarball installation
  -s, --self              Update Orion itself from GitHub
  rollback                Manage Orion backups/rollbacks
  -h, --help              Show this help message
  -v, --version           Show version

${CYAN}Examples:${RESET}
  orion -l                 List all packages
  orion -u discord         Update Discord
  orion -a                 Update all packages
  orion -s                 Update Orion from GitHub
  orion rollback --help    Show rollback help

${CYAN}Rollback Commands:${RESET}
  orion rollback --list        List available backups
  orion rollback --backup      Create new Orion backup
  orion rollback BACKUP_ID     Restore from backup
  orion rollback latest        Restore latest backup
  orion rollback --clean       Clean old backups

${CYAN}Directories:${RESET}
  Installation:   $INSTALL_DIR
  Modules:        $MODULES_DIR
  Logs:           $LOG_DIR
  Backups:        $BACKUP_DIR
EOF
}