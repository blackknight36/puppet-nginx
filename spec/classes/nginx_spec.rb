require 'spec_helper'
require 'shared_contexts'

describe 'nginx' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_package("collectd-nginx") .with({ "ensure" => "installed", }) }
      it { is_expected.to contain_package("nginx") .with({ "ensure" => "installed", }) }

      it do
        is_expected.to contain_file("/etc/collectd.d/nginx.conf")
            .with({
              "source" => "puppet:///modules/nginx/collectd.d/nginx.conf",
              "require" => "Package[collectd-nginx]",
              "notify" => "Service[collectd]",
            })
      end

      context "conf_source => 'puppet:///modules/nginx/nginx.conf'" do
        let(:params) {{
          :conf_source => 'puppet:///modules/nginx/nginx.conf'
        }}

        it do
          is_expected.to contain_file("/etc/nginx/nginx.conf")
              .with({
                "source" => 'puppet:///modules/nginx/nginx.conf',
              })
              .that_requires('Package[nginx]')
        end
      end

      context "conf_content => 'test'" do
        let(:params) {{
          :conf_content => 'test'
        }}

        it do
          is_expected.to contain_file("/etc/nginx/nginx.conf")
              .with({
                "source" => nil,
                "content" => 'test',
              })
              .that_requires('Package[nginx]')
        end
      end

      it do
        is_expected.to contain_service("nginx")
            .with({
              "ensure" => "running",
              "enable" => true,
            })
      end

      context "manage_firewall => true" do
        let(:params) {{
          :manage_firewall => true
        }}

        it { is_expected.to contain_class('nginx::firewall::http') }
      end

      context "use_nfs => true" do
        let(:facts) { facts.merge(:selinux => true) }

        let(:params) {{
          :use_nfs => true
        }}

        it do
          is_expected.to contain_selboolean("httpd_use_nfs")
            .with({
              "value" => "on",
              "persistent" => true,
            })
        end
      end

      context "use_nfs => false" do
        let(:facts) { facts.merge(:selinux => true) }

        let(:params) {{
          :use_nfs => false
        }}

        it do
          is_expected.to contain_selboolean("httpd_use_nfs")
            .with({
              "value" => "off",
              "persistent" => true,
            })
        end
      end

    end
  end
end
