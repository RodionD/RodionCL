# Calculate
#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    raw:       any valid Openbox XML string               {raw => q(xml string)},
    begin_cat: begin of a category                  {begin_cat => ["name", "icon"]},
    end_cat:   end of a category                      {end_cat => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

#?os_locale_language!=ru#
our $SCHEMA = [

    #          COMMAND                 LABEL                ICON
    {item => ['spacefm',        'File Manager',      'file-manager']},
    {item => [$CONFIG->{terminal},             'Terminal',          'terminal']},
    {item => ['firefox', 'Web Browser',       'web-browser']},
    {item => ['gmrun',             'Run command',       'system-run']},

    {sep => 'Categories'},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Other',       'applications-other']},
    {cat => ['settings',    'Settings',    'applications-accessories']},
    {cat => ['system',      'System',      'applications-system']},

    #{cat => ['qt',          'QT Applications',    'qt4logo']},
    #{cat => ['gtk',         'GTK Applications',   'gnome-applications']},
    #{cat => ['x_xfce',      'XFCE Applications',  'applications-other']},
    #{cat => ['gnome',       'GNOME Applications', 'gnome-applications']},
    #{cat => ['consoleonly', 'CLI Applications',   'applications-utilities']},

    #                  LABEL          ICON
    #{begin_cat => ['My category',  'cat-icon']},
    #             ... some items ...
    #{end_cat   => undef},

    #            COMMAND     LABEL        ICON
    #{pipe => ['/usr/local/bin/obdevicemenu', 'Device menu', 'drive-harddisk']},

    ## Generic advanced settings
    #{sep       => undef},
    #{obgenmenu => ['Openbox Settings', 'openbox']},
    #{sep       => undef},

    ## Custom advanced settings
    {sep => undef},
    {begin_cat => ['Advanced Settings', 'gnome-settings']},

        # Configuration files
        {item => ["$editor ~/.config/tint2/tint2rc", 'Tint2 Panel', 'text-x-source']},

        # obmenu-generator category
        {begin_cat => ['Obmenu-Generator', 'menu-editor']},
            {item => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-source']},
            {item => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-source']},

            {sep  => undef},
            {item => ['obmenu-generator -p',       'Generate a pipe menu',              'menu-editor']},
            {item => ['obmenu-generator -s -c',    'Generate a static menu',            'menu-editor']},
            {item => ['obmenu-generator -p -i',    'Generate a pipe menu with icons',   'menu-editor']},
            {item => ['obmenu-generator -s -i -c', 'Generate a static menu with icons', 'menu-editor']},
            {sep  => undef},

            {item => ['obmenu-generator -d', 'Refresh Icon Set', 'gtk-refresh']},
        {end_cat => undef},

        # Openbox category
        {begin_cat => ['Openbox', 'openbox']},
            {item => ['openbox --reconfigure',               'Reconfigure Openbox', 'openbox']},
            {item => ["$editor ~/.config/openbox/autostart", 'Openbox Autostart',   'shellscript']},
            {item => ["$editor ~/.config/openbox/rc.xml",    'Openbox RC',          'text-xml']},
            {item => ["$editor ~/.config/openbox/menu.xml",  'Openbox Menu',        'text-xml']},
        {end_cat => undef},

    {end_cat => undef},
    {sep => undef},

    ## The xscreensaver lock command
    {item => ['xscreensaver-command -lock', 'Lock', 'lock']},

    # This option uses the default Openbox's action "Exit"
    {item => ['gxshutdown', 'Exit', 'exit']},

    # This uses the 'oblogout' menu
    # {item => ['oblogout', 'Exit', 'exit']},
]
#os_locale_language#
#?os_locale_language==ru#

our $SCHEMA = [

    #          COMMAND                 LABEL                ICON
    {item => ['spacefm',        'Файловый менеджер',      'file-manager']},
    {item => [$CONFIG->{terminal},             'Терминал',          'terminal']},
    {item => ['firefox', 'Web браузер',       'web-browser']},
    {item => ['gmrun',             'Выполнить комманду',       'system-run']},

    {sep => 'Categories'},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Служебные', 'applications-utilities']},
    {cat => ['development', 'Разработка', 'applications-development']},
    {cat => ['education',   'Образование',   'applications-science']},
    {cat => ['game',        'Игры',       'applications-games']},
    {cat => ['graphics',    'Графика',    'applications-graphics']},
    {cat => ['audiovideo',  'Мультимедия',  'applications-multimedia']},
    {cat => ['network',     'Сеть',     'applications-internet']},
    {cat => ['office',      'Офис',      'applications-office']},
    {cat => ['other',       'прочее',       'applications-other']},
    {cat => ['settings',    'Настройки',    'applications-accessories']},
    {cat => ['system',      'Система',      'applications-system']},

    #{cat => ['qt',          'QT Applications',    'qt4logo']},
    #{cat => ['gtk',         'GTK Applications',   'gnome-applications']},
    #{cat => ['x_xfce',      'XFCE Applications',  'applications-other']},
    #{cat => ['gnome',       'GNOME Applications', 'gnome-applications']},
    #{cat => ['consoleonly', 'CLI Applications',   'applications-utilities']},

    #                  LABEL          ICON
    #{begin_cat => ['My category',  'cat-icon']},
    #             ... some items ...
    #{end_cat   => undef},

    #            COMMAND     LABEL        ICON
    #{pipe => ['/usr/local/bin/obdevicemenu', 'Меню устройств', 'drive-harddisk']},

    ## Generic advanced settings
    #{sep       => undef},
    #{obgenmenu => ['Openbox Settings', 'openbox']},
    #{sep       => undef},

    ## Custom advanced settings
    {sep => undef},
    {begin_cat => ['Расширенные настройки', 'gnome-settings']},

        # Configuration files
        {item => ["$editor ~/.config/tint2/tint2rc", 'Панель Tint2', 'text-x-source']},

        # obmenu-generator category
        {begin_cat => ['Obmenu-Generator', 'menu-editor']},
            {item => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-source']},
            {item => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-source']},

            {sep  => undef},
            {item => ['obmenu-generator -p',       'Генерация динамического меню',              'menu-editor']},
            {item => ['obmenu-generator -s -c',    'Генерация статического меню',            'menu-editor']},
            {item => ['obmenu-generator -p -i',    'Генерация динамического меню с иконками',   'menu-editor']},
            {item => ['obmenu-generator -s -i -c', 'Генерация статического меню с иконками', 'menu-editor']},
            {sep  => undef},

            {item => ['obmenu-generator -d', 'Refresh Icon Set', 'gtk-refresh']},
        {end_cat => undef},

        # Openbox category
        {begin_cat => ['Openbox', 'openbox']},
            {item => ['openbox --reconfigure',               'Реконфигурация Openbox', 'openbox']},
            {item => ["$editor ~/.config/openbox/autostart", 'Openbox Autostart',   'shellscript']},
            {item => ["$editor ~/.config/openbox/rc.xml",    'Openbox RC',          'text-xml']},
            {item => ["$editor ~/.config/openbox/menu.xml",  'Openbox Menu',        'text-xml']},
        {end_cat => undef},

    {end_cat => undef},
    {sep => undef},

    ## The xscreensaver lock command
    {item => ['xscreensaver-command -lock', 'Блокировка', 'lock']},

    # This option uses the default Openbox's action "Exit"
    {item => ['gxshutdown', 'Выход', 'exit']},

    # This uses the 'oblogout' menu
    # {item => ['oblogout', 'Exit', 'exit']},
]
#os_locale_language#
