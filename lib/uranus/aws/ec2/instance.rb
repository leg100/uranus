require 'uranus/exceptions'
require 'uranus/utils'
require 'aws-sdk'

module Uranus
  module Aws
    module EC2
      class Instance
        Properties = [:instance_type, :image_id, :key_name, :subnet_id, :security_groups, :tags]
        attr_accessor *Properties

        def initialize(params)
          params.each{|k,v|
            self.send("#{k}=", v)
          }
        end

        def uranus_id
          result = self.tags.find{|t| t[:key] == 'uranus_id'}
          raise Uranus::MissingUranusIdException if result.nil?

          result[:value]
        end

        def current
          results = ::Aws::EC2::Client.new.describe_tags(filters: [
            {name: 'resource-type', values: ['instance']},
            {name: 'tag:uranus_id', values: [ self.uranus_id ]}
          ]).tags

          return nil if results.empty?

          raise Uranus::DuplicateResourceException if results.length > 1

          data = ::Aws::EC2::Instance.new(results.first.resource_id).data.to_h.select{|k,v|
            Properties.include? k
          }
          data[:security_groups] = data[:security_groups].map{|sg| sg[:group_id] }
          data
        end

        def desired
          Properties.inject(Hash.new){|h,p|
            h[p] = self.send(p)
            h
          }
        end
      end
    end
  end
end
