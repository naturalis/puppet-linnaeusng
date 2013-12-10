# Create all virtual hosts from hiera
class nsr::instances (
    $instances,
)
{
  create_resources('apache::vhost', $instances)
}
