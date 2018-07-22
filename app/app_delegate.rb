class AppDelegate

  TOOLBAR_IDENTIFIER = "AppToolbar"
  MAIN_LAYOUT_TOOLBAR_ITEM_ID = "MainToolbarItem"
  SECOND_LAYOUT_TOOLBAR_ITEM_ID = "SecondToolbarItem"
  RESET_TOOLBAR_ITEM_ID = "ResetToolbarItem"

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [960, 720]],
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

    @current_state_button = @main_layout.get(:current_state_button)
    @current_state_button.target = self
    @current_state_button.action = 'current_state'
    @current_state_result = @main_layout.get(:current_state_result)

    @accounts_button = @main_layout.get(:accounts_button)
    @accounts_button.target = self
    @accounts_button.action = 'eth_accounts'
    @accounts_result = @main_layout.get(:accounts_result)

    @confirm_payment_button = @main_layout.get(:confirm_payment_button)
    @confirm_payment_button.target = self
    @confirm_payment_button.action = 'confirm_payment'

    @confirm_delivery_button = @main_layout.get(:confirm_delivery_button)
    @confirm_delivery_button.target = self
    @confirm_delivery_button.action = 'confirm_delivery'

    @refund_buyer_button = @main_layout.get(:refund_buyer_button)
    @refund_buyer_button.target = self
    @refund_buyer_button.action = 'refund_buyer'

    @function_selector = ""


  end

  def toolbarAllowedItemIdentifiers(toolbar)
    [RESET_TOOLBAR_ITEM_ID, MAIN_LAYOUT_TOOLBAR_ITEM_ID, SECOND_LAYOUT_TOOLBAR_ITEM_ID]
  end

  def toolbarDefaultItemIdentifiers(toolbar)
    [RESET_TOOLBAR_ITEM_ID, MAIN_LAYOUT_TOOLBAR_ITEM_ID, SECOND_LAYOUT_TOOLBAR_ITEM_ID]
  end

  def toolbar(toolbar, itemForItemIdentifier: identifier, willBeInsertedIntoToolbar: flag)
    if identifier == RESET_TOOLBAR_ITEM_ID
      reset = NSToolbarItem.alloc.initWithItemIdentifier(RESET_TOOLBAR_ITEM_ID)
      reset.label = "Reset"
      reset.toolTip = "Reset the Contract State back to AWAITING_PAYMENT"
      reset.target = self
      reset.action = 'reset_button_hit:'
      reset
    elsif identifier == MAIN_LAYOUT_TOOLBAR_ITEM_ID
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

  def reset_button_hit(toolbar)
    reset_state()
  end

  def second_button_hit(toolbar)
    @mainWindow.contentView = @second_layout.view
  end

  def main_button_hit(toolbar)
    @mainWindow.contentView = @main_layout.view
  end




end
