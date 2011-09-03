class unbound {
  include unbound::params

  $unbound_confdir = $unbound::params::unbound_confdir
  $unbound_logdir  = $unbound::params::unbound_logdir
  $unbound_service = $unbound::params::service

  package { "unbound":
    ensure   => installed,
    provider => $kernel ? {
      Darwin  => macports,
      default => undef,
    }
  }

  service { "unbound":
    name      => $unbound_service,
    ensure    => running,
    enable    => true,
    pattern   => "unbound",
    hasstatus => false,
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => "$unbound_confdir/unbound.conf",
    content => template("unbound/unbound.conf.erb"),
  }

  concat { "$unbound_confdir/unbound.conf":
    notify => Service["unbound"],
  }

  file { "$unbount_confdir/root.key":
    owner   => "unbound",
    group   => "unbound",
    content => ". IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5",
    replace => false,
  }

}

