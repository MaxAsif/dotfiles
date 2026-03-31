function bind_both_modes_default_and_insert
    # FYI this is for using vi-mode, to bind in both normal and default modes
    #  default also works in non-vi-mode (emacs like)
    #  NOTE default == normal in vi-mode
    bind -M default $argv
    bind -M insert $argv
end
# *** fzf "pickers" for selecting a file to pass to a command
# --- fzf per-directory MRU cache --------------------------------------------

set -g FZF_MRU_DIR ~/.cache/fzf-mru
set -g FZF_MRU_CAP 30 # per dir limit, only most recent are gonna matter anyways

function __fzf_mru_key
    pwd | shasum | string split ' ' | head -n 1
end

function __fzf_mru_file --argument-names picker
    set -l dir $FZF_MRU_DIR/$picker
    mkdir -p $dir

    set -l file $dir/(__fzf_mru_key)

    # so it always exists (i.e. so `grep -Fxv` in consumers doesn't blow up on a missing file)
    test -f $file; or touch $file

    echo $file
end

function __fzf_mru_read --argument-names picker
    set -l file (__fzf_mru_file $picker)
    test -f $file; or return

    cat $file | while read -l path
        # check that the files still exist
        test -e "$path"; and echo "$path"
        # PRN async write (fire and forget) to save filtered list into file?
    end
end

function __fzf_mru_write --argument-names picker path
    # normalize cleans up path ... but, the path should always be the same assuming I only ever save selections from fzf to the cache
    #   i.e. ./foo/bar => foo/bar
    #        foo/bar => foo/bar
    set path (path normalize "$path")

    set -l file (__fzf_mru_file $picker)

    set temp_new_file (mktemp)
    begin
        echo "$path"
        test -f $file; and grep -Fxv -- "$path" $file
    end | head -n $FZF_MRU_CAP >$temp_new_file
    mv $temp_new_file $file
end

function __fzf_picker --argument-names picker fd_command
    set -l current_word (commandline --current-token)

    set -l fzf_opts --height 50% --border --header "MRU ↑  |  Fresh ↓"
    if test -n "$current_word"
        # can type `cd foo<alt-shift-d>` and fzf opens with `foo` prefilled
        #  effectively start filtering before and/or after deciding to use fzf picker
        set fzf_opts $fzf_opts --query $current_word
    end

    set -l file (
        begin
            set -l mru_file (__fzf_mru_file $picker)
            __fzf_mru_read $picker
            eval $fd_command | grep -Fxv -f $mru_file
        end | fzf $fzf_opts
    )

    if test -n "$file"
        __fzf_mru_write $picker "$file"

        # * remove current token b/c it was a temporary search term only (else file tacked onto end of it)
        #  DO NOT remove token if no file picked, b/c user might want to switch pickers (w/o retyping query)
        #  i.e. start w/ regular file picker => realize its a hidden file => switch to unrestricted file picker
        if test -n "$current_word"
            # FTR `commandline foo` replaces entire commandline w/ `foo`
            #   add -t/--current-token to limit replacement to the current token only
            commandline --current-token -- "" # empty == remove current token
        end

        # insert file at cursor position
        commandline --insert -- (string escape -- "$file")
    end

    commandline --function repaint
end

# ---------------------------------------------------------------------------

function _fzf_nested_dir_picker -d "Paste selected directory into command line"
    __fzf_picker dirs "fd --type d ."
end

function _fzf_nested_file_picker -d "Paste selected file into command line"
    __fzf_picker files "fd --type f ."
end

function _fzf_nested_file_unrestricted_picker
    __fzf_picker unrestricted "fd --type f . -u"
end

function _fzf_nested_both_file_and_dirs_picker -d "Paste selected file or directory into command line"
    # btw `diff_two_commands 'fd --type f --type d' 'fd'` differ in symlinks (at least)
    __fzf_picker both "fd ."
end

bind_both_modes_default_and_insert alt-shift-d _fzf_nested_dir_picker
bind_both_modes_default_and_insert alt-shift-f _fzf_nested_file_picker
bind_both_modes_default_and_insert alt-shift-u _fzf_nested_file_unrestricted_picker
bind_both_modes_default_and_insert alt-shift-b _fzf_nested_both_file_and_dirs_picker
