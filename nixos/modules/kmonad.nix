{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.kmonad;

in {
  options.modules.kmonad = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable KMonad.";
      default = true; # XXX
    };
  };

  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true;
      keyboards.internal = {
        name = "laptop-internal";
        device = "/dev/input/by-id/usb-Apple_Inc._Apple_Internal_Keyboard___Trackpad-event-kbd";

        defcfg = {
          enable = true;
          fallthrough = true;
        };

        config = ''
          (defsrc
            grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
            tab      q        w        e        r        t        y        u        i        o        p        [        ]        \
            caps     a        s        d        f        g        h        j        k        l        ;        '        ret
            lsft     z        x        c        v        b        n        m        ,        .        /        rsft
            lctl     lalt     lmet                       spc                        rmet     ralt              up
                                                                                                      left     down     rght
          )

          (defalias
            colemak (layer-switch colemak)
            ctl_esc (tap-hold-next-release 200 esc lctl)
            ctl_ret (tap-hold-next-release 200 ret rctl)
            nav_spc (tap-hold-next-release 200 spc (layer-toggle nav))
            qwerty (layer-switch qwerty)
            tmux A-o
          )

          (deflayer qwerty
            grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
            tab      q        w        e        r        t        y        u        i        o        p        [        ]        \
            caps     a        s        d        f        g        h        j        k        l        ;        '        ret
            lsft     z        x        c        v        b        n        m        ,        .        /        rsft
            lctl     lalt     lmet                       @nav_spc                   rmet     ralt              up
                                                                                                      left     down     rght
          )

          (deflayer colemak
            grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
            tab      q        w        f        p        g        j        l        u        y        '        bspc     bspc     bspc
            @ctl_esc a        r        s        t        d        h        n        e        i        o        @ctl_ret @ctl_ret
            lsft     z        x        c        v        b        k        m        ,        .        /        rsft
            lctl     lalt     lmet                       @nav_spc                   rmet     ralt              up
                                                                                                      left     down     rght
          )

          (deflayer nav
            _        _        _        _        _        _        _        _        _        _        _        _        _        _
            _        @qwerty  @colemak _        _        _        _        _        _        _        _        _        _        _
            _        _        _        _        _        _        @tmux    left     down     up       rght     _        _
            _        _        _        _        _        _        _        home     pgdn     pgup     end      _
            _        _        _                          _                          _        _                 _
                                                                                                      _        _        _
          )
        '';
      };
    };
  };
}
