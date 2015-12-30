{
  ec2_instance: {
    instance_type: 't2.micro',
    image_id: 'ami-e4d18e93',
    key_name: 'louisgarman',
    subnet_id: 'subnet-cad8a2bd',
    security_groups: ['sg-ec1dd288'],
    tags: [{
      key: 'uranus_id', value: 'my-one-and-only-instance'
    }]
  }
}
