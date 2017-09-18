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

      it do
        is_expected.to contain_file("/usr/share/nginx/html/index.html")
            .with({
              "ensure" => "file",
              })
      end

      it do
        is_expected.to contain_file("/etc/nginx/nginx.conf")
            .with({
              "source" => "puppet:///modules/nginx/nginx.conf",
              "require" => "Package[nginx]",
              })
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

        it { is_expected.to contain_firewall('100 allow http')
          .with({
            "dport" => "80",
            "proto" => "tcp",
            "action" => "accept",
          })
        }
      end

      context "use_nfs => true" do
        let(:params) {{
          :use_nfs => true
        }}

        it { is_expected.to contain_selboolean("httpd_use_nfs") .with({ "value" => "on", }) }
      end

    end
  end
end
