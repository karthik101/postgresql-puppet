class psql-test {

package {'pgdg-redhat93-9.3-1.noarch':
ensure => installed,
source => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm',
provider => 'rpm',
}


class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.3',
} -> 
class { 'postgresql::server':
  listen_addresses  => '*',
  postgres_password => 'starlord',
}

postgresql::server::db { 'mydb':
  user     => 'star',
  password => postgresql_password('star', 'starlord'),
}

# rule for remote connections
postgresql::server::pg_hba_rule { 'allow remote connections with password':
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '0.0.0.0/0',
  auth_method => 'md5',
}

file {'/var/lib/pgsql/9.3/data/postgresql.conf':
ensure => 'present',
source => 'puppet:///modules/psql-test/postgresql.conf',
notify  => Class['postgresql::server::service'],
}
}
