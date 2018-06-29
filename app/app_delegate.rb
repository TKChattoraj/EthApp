class AppDelegate

  TOOLBAR_IDENTIFIER = "AppToolbar"
  MAIN_LAYOUT_TOOLBAR_ITEM_ID = "MainToolbarItem"
  SECOND_LAYOUT_TOOLBAR_ITEM_ID = "SecondToolbarItem"

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    @mainWindow.delegate = self

    @toolbar = NSToolbar.alloc.initWithIdentifier(TOOLBAR_IDENTIFIER)
    @toolbar.displayMode = NSToolbarDisplayModeLabelOnly
    @toolbar.delegate = self
    @mainWindow.setToolbar(@toolbar)

    @main_layout = MainLayout.new
    @second_layout = SecondLayout.new
    @mainWindow.contentView = @main_layout.view

    @main_button = @main_layout.get(:main_button)
    @main_button.target = self
    @main_button.action = 'keccak_256'
    @main_button_result = @main_layout.get(:main_button_result)

    @accounts_button = @main_layout.get(:accounts_button)
    @accounts_button.target = self
    @accounts_button.action = 'eth_accounts'
    @accounts_result = @main_layout.get(:accounts_result)


  end

  def toolbarAllowedItemIdentifiers(toolbar)
    [MAIN_LAYOUT_TOOLBAR_ITEM_ID, SECOND_LAYOUT_TOOLBAR_ITEM_ID]
  end

  def toolbarDefaultItemIdentifiers(toolbar)
    [MAIN_LAYOUT_TOOLBAR_ITEM_ID, SECOND_LAYOUT_TOOLBAR_ITEM_ID]
  end

  def toolbar(toolbar, itemForItemIdentifier: identifier, willBeInsertedIntoToolbar: flag)
    if identifier == MAIN_LAYOUT_TOOLBAR_ITEM_ID
      main = NSToolbarItem.alloc.initWithItemIdentifier(MAIN_LAYOUT_TOOLBAR_ITEM_ID)
      main.label = "Main"
      main.toolTip = "Go to Main View"
      main.target = self
      main.action = 'main_button_hit:'
      main
    elsif identifier == SECOND_LAYOUT_TOOLBAR_ITEM_ID
      second = NSToolbarItem.alloc.initWithItemIdentifier(SECOND_LAYOUT_TOOLBAR_ITEM_ID)
      second.label = "Second"
      second.toolTip = "Go to Second View"
      second.target = self
      second.action = 'second_button_hit:'
      second
    else
      nil
    end

  end

  def second_button_hit(toolbar)
    @main_button_result.stringValue = "Main Button Result"
    @mainWindow.contentView = @second_layout.view
  end

  def main_button_hit(toolbar)
    @mainWindow.contentView = @main_layout.view
  end

  #returns the Keccak-256 Hash (not the standardized SHA3-256) given a hex string of data
  def keccak_256
    @address = "http://127.0.0.1:8545"
    #params is the rpc array (of objects) in the rpc data hash
    params = ["0x68656c6c6f20776f726c64"]
    # data is the 'data' hash of the json rpc consisting of "jsonrpc", "method", "params" and "id" keys.
    # "method" is the key in the data hash calling the json rpc method
    # "params" is the params array (of ojbects) needed for the json rpc method called
    data = {"jsonrpc" => "2.0", "method" => "web3_sha3", "params" => params, "id" => ":64"}
    options = {payload: data, format: :json}

    BubbleWrap::HTTP.post(@address, options) do |response|
      #NSLog(response.body.to_str)
      if response.ok?
        response_body = BubbleWrap::JSON.parse(response.body.to_str)
      elsif response.status_code.to_s =~ /40\d/
        alert = NSAlert.alloc.init
        alert.setMessageText "Failed"
        alert. addButtonWithTitle "OK"
        alert.runModal
      else
        alert = NSAlert.alloc.init
        alert.setMessageText response.error_message
        alert.addButtonWithTitle "OK"
        alert.runModal

      end
      NSLog(response_body.to_s)
      @main_button_result.stringValue = response_body["result"]

    end

  end

  def eth_accounts
    #@address = "http://127.0.0.1:8545"
    params = []
    data = {"jsonrpc" => "2.0", "method" => "eth_accounts", "params" => params, "id" => ":1"}
    http_Client = HttpClient.new
    response_body = http_Client.post(data) do |response|
      NSLog(response.to_s)
      @accounts_result.stringValue = response
    end

  end




end
