class MainLayout <MotionKit::Layout
  SIZE = [150, 30]

  TAB_VIEW_ITEM_IDENTIFIER = "TabViewItem"

  def layout

    add NSButton, :current_state_button do
      title "Current State"
      size_to_fit
      constraints do
        top.equals(:superview, :top).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end

    add NSTextField, :current_state_result do
      constraints do
        top.equals(:current_state_button, :bottom).plus(10)
        left.equals(:superview, :left).plus(20)
        height.is(20)
        width.is(200)
      end
      StringValue "Current State"
      editable true
      selectable true
    end

    add NSButton, :accounts_button do
      title "Accounts"
      size_to_fit
      constraints do
        top.equals(:current_state_result, :bottom).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end

    add NSTextField, :accounts_result do
      constraints do
        top.equals(:accounts_button, :bottom).plus(10)
        left.equals(:superview, :left).plus(20)
        height.is(200)
        width.is(200)
      end
      StringValue "Accounts Button Result"
      editable true
      selectable true
    end

    add NSButton, :confirm_payment_button do
      title "Confirm Payment"
      size_to_fit
      constraints do
        top.equals(:accounts_result, :bottom).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end

    add NSButton, :confirm_delivery_button do
      title "Confirm Delivery"
      size_to_fit
      constraints do
        top.equals(:confirm_payment_button, :bottom).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end

    add NSButton, :refund_buyer_button do
      title "Refund Buyer"
      size_to_fit
      constraints do
        top.equals(:confirm_delivery_button, :bottom).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end










  end
end
