# Create all virtual hosts from hiera
class nsr::instances
{
  create_resources('apache::vhost', hiera('nsr', []))

}
