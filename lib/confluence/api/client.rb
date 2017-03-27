require "confluence/api/client/version"
require 'json'
require 'faraday'
require 'mimemagic'

module Confluence
  module Api
    class Client
      attr_accessor :user, :pass, :url, :conn, :multiconn
      def initialize(user, pass, url)
        self.user = user
        self.pass = pass
        self.url = url
        self.conn = Faraday.new(url: url ) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end
        self.multiconn = Faraday.new(url: url ) do |faraday|
          faraday.request  :multipart             # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end


      end

      def get(params)
        response = conn.get('/wiki/rest/api/content', params)
        JSON.parse(response.body)['results']
      end

      def get_by_id(id)
        response = conn.get('/wiki/rest/api/content/' + id)
        JSON.parse(response.body)
      end

      def upload_file(page_id,file_path)
        response = multiconn.post do |req|
          req.url '/wiki/rest/api/content/'+page_id+'/child/attachment'
          req.headers['X-Atlassian-Token']= 'nocheck'
          req.body= {file: Faraday::UploadIO.new(File.open(file_path), MimeMagic.by_magic(File.open(file_path))) }
        end
        JSON.parse(response.body)
      end

      def get_attachments_by_name(page_id,attachment_name)
        response = conn.get('/wiki/rest/api/content/' + page_id + '/child/attachment?filename='+attachment_name)
        JSON.parse(response.body)
      end

      def update_file(page_id,attachment_id,file_path)
        response = multiconn.post do |req|
          req.url '/wiki/rest/api/content/'+page_id+'/child/attachment/' + attachment_id + '/data'
          req.headers['X-Atlassian-Token']= 'nocheck'
          req.body= {file: Faraday::UploadIO.new(File.open(file_path), MimeMagic.by_magic(File.open(file_path))) }
        end
        JSON.parse(response.body)
      end

      def create(params)
        response = conn.post do |req|
          req.url '/wiki/rest/api/content'
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
        JSON.parse(response.body)
      end

      def update(id, params)
        response = conn.put do |req|
          req.url "/wiki/rest/api/content/#{id}"
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
        JSON.parse(response.body)
      end

    end
  end
end
