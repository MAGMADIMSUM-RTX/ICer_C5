set_app_var search_path [concat $search_path $ADDITIONAL_SEARCH_PATH]
set_app_var target_library $TARGET_LIBRARY_FILES
set_app_var link_library [concat {*} $TARGET_LIBRARY_FILES [list $IO_LIBRARY_FILE]]
set_app_var symbol_library $SYMBOL_LIBRARY_FILES
set_app_var synthetic_library dw_foundation.sldb
set_app_var link_library [concat $link_library $synthetic_library]
