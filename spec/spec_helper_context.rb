class Context
  attr_reader :cookie

  def initialize(url = '/', base = '/')
    @base     = base
    @history  = []
    @http     = SimpleHttp.new(url2uri(url))
    @cookie   = get_cookie
    @http.request_headers['cookie'] = @cookie
  end

  def get_cookie
    @http.get
    @history << @http.uri
    @http.response_headers['set-cookie']
  end

  def get url = '/', hash = {}
    request(:get, url, hash)
  end

  def post url = '/', hash = {}
    request(:post, url, hash)
  end

  def erequest method, url, hash = {}
    response = request(method, url, hash)
    eval(response)
  rescue Object => ex
    p :response => response
    ex.message
  end

  def epost url = '/', hash = {}
    erequest(:post, url, hash)
  end

  def eget url = '/', hash = {}
    erequest(:get, url, hash)
  end

  def request method, url, hash = {}
    @http.uri = url2uri(url)
    @http.request_headers['referer'] = @history.last.path

    if method == :get and not hash.empty?
      @http.uri.query = hash.inject([]){|s,(k,v)| s << "#{k}=#{v}"}.join('&')
      hash.clear
    end

    puts "#{method.to_s.upcase} => #{@http.uri}"
    response = @http.send(method, hash).strip
    @history << @http.uri
    response
  end

  def url2uri url
    uri = URI.parse(url)
    uri.scheme = 'http'
    uri.host = 'localhost'
    uri.port = Ramaze::Global.port
    uri.path = "/#{@base}/#{url}".squeeze('/')
    uri
  end
end
