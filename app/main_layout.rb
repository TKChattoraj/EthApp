class MainLayout <MotionKit::Layout
  SIZE = [150, 30]

  TAB_VIEW_ITEM_IDENTIFIER = "TabViewItem"

  def layout

    add NSButton, :main_button do
      title "Hit Me"
      size_to_fit
      constraints do
        top.equals(:superview, :top).plus(20)
        left.equals(:superview, :left).plus(20)
      end
    end
    



    # add NSTabView, :content_tabs do
    #   constraints do
    #     width.equals(:superview)
    #     height.equals(:superview)
    #   end
    #
    #   add_tab "TabViewItem_Tab1", "Tab 1" do
    #     wantsLayer true
    #
    #     constraints do
    #       width.equals(:superview).minus(10)
    #       height.equals(:superview).minus(10)
    #     end
    #     backgroundColor NSColor.lightGrayColor
    #
    #   end
    #
    #   add_tab "TabViewItem_Tab2", "Tab 2" do
    #     wantsLayer true
    #
    #     constraints do
    #       width.equals(:superview).minus(10)
    #       height.equals(:superview).minus(10)
    #     end
    #     backgroundColor NSColor.lightGrayColor
    #   end
    #
    # end

  end
end
