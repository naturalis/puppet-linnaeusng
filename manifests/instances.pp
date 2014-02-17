# Create all virtual hosts from hiera
class linnaeusng::instances (
    $instances,
)
{
  create_resources('apache::vhost', $instances)
}
