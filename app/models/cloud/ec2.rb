module Cloud
  class Ec2

    def initialize(cloud_username, cloud_password)
      @cloud_username = cloud_username
      @cloud_password = cloud_password
    end

    def instances
      select_instances.map do |aws|
        Instance.new(
                     :id            => aws[:aws_instance_id],
                     :image_id      => aws[:aws_image_id],
                     :key_pair_name => aws[:ssh_key_name],
                     :public_dns    => aws[:dns_name],
                     :status        => aws[:aws_state]
                     )
      end
    end

    def select_instances
      all = client.describe_instances
      RAILS_DEFAULT_LOGGER.debug("ec2.describe_instances (#{all.size}) -> #{all.map{|x|%Q{#{x[:aws_instance_id]}:#{x[:aws_image_id]}:#{x[:aws_state]}}}.join(' | ')}")
      all.select{|x| APP_CONFIG['image_ids'].include?(x[:aws_image_id])}
    end

    def launch image_id, key_pair_name
      launched = client.launch_instances(image_id, :key_name => key_pair_name, :user_data => user_data)
      RAILS_DEFAULT_LOGGER.debug("ec2.launch_instances returned #{launched.size}")
    end

    def terminate instance_id
      terminated = client.terminate_instances [instance_id]
      RAILS_DEFAULT_LOGGER.debug("ec2.terminate_instances returned #{terminated.size}")
    end

    def client
      @client ||= Aws::Ec2.new(@cloud_username, @cloud_password)
    end

    def user_data(bucket)
      Base64.encode64(["access_key: #{@cloud_username}",
                       "secret_access_key: #{@cloud_password}",
                       "bucket: #{bucket}"
                      ].join("\n"))
    end

  end
end
