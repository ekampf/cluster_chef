ClusterChef.cluster 'bonobo' do
  use :defaults
  setup_role_implications

  recipe                "hadoop_cluster::system_internals"
  role                  "nfs_client"
  role                  "infochimps_base"
  role                  "big_package"
  role                  "hadoop"
  role                  "hadoop_worker"

  recipe                "cluster_chef::dedicated_server_tuning"
  recipe                "hadoop_cluster::std_hdfs_dirs"

#  role                  "hadoop_s3_keys"
  cloud do
    flavor              "m1.xlarge"
    backing             "ebs"
    image_name          "infochimps-maverick-client"
    #user_data           :get_name_from => 'broham'
  end

  facet 'master' do
    instances           1
    role                "hadoop_master"
    role                "super_herder_server"
    role                  "super_herder_worker"
    role                  "herder_worker"
  end

  facet 'worker' do
    instances           29
  end

  chef_attributes({
      :cluster_size => facet('worker').instances + facet('master').instances,
    })
end
