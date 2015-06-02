# Create all virtual hosts from hiera
class linnaeusng::instances (
    $instances  = undef,
)
{
  create_resources('apache::vhost', $instances)
}
