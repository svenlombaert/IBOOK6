package be.devine.cp3.view.elements {
import be.devine.cp3.style.Style;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class PageNumberElement extends Sprite{

    private var pageNumber:int;

    public function PageNumberElement(pageNumber:int) {
        this.pageNumber = pageNumber;
        var t:TextField = new TextField(50, 20, '- p' + pageNumber + ' -', Style.FONT , 12, 0x666666, true);
        t.vAlign = VAlign.TOP;
        t.hAlign = HAlign.CENTER;
        //t.border = true;
        addChild(t);

    }
}
}
