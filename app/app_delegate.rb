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

    #create the HTTP Client to connect to the JSON RPC
    @http_client = HTTPClient.new

    @toolbar = NSToolbar.alloc.initWithIdentifier(TOOLBAR_IDENTIFIER)
    @toolbar.displayMode = NSToolbarDisplayModeLabelOnly
    @toolbar.delegate = self
    @mainWindow.setToolbar(@toolbar)

    @main_layout = MainLayout.new
    @second_layout = SecondLayout.new
    @mainWindow.contentView = @main_layout.view

    @main_button = @main_layout.get(:main_button)
    @main_button.target = self
    @main_button.action = 'contract_method'
    @main_button_result = @main_layout.get(:main_button_result)

    @accounts_button = @main_layout.get(:accounts_button)
    @accounts_button.target = self
    @accounts_button.action = 'eth_accounts'
    @accounts_result = @main_layout.get(:accounts_result)

    @function_selector = ""


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




end
