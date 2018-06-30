class MainLayout <MotionKit::Layout
  SIZE = [150, 30]

  TAB_VIEW_ITEM_IDENTIFIER = "TabViewItem"

  def layout

    add NSButton, :main_button do
      title "Method_ID"
      size_to_fit
      constraints do
        top.equals(:superview, :top).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end

    add NSTextField, :main_button_result do
      constraints do
        top.equals(:main_button, :bottom).plus(10)
        left.equals(:superview, :left).plus(20)
        height.is(20)
        width.is(200)
      end
      StringValue "Main Button Result"
      editable true
      selectable true
    end

    add NSButton, :accounts_button do
      title "Accounts"
      size_to_fit
      constraints do
        top.equals(:main_button_result, :bottom).plus(20)
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
  end
end
