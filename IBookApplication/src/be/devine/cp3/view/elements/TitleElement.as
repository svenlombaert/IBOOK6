/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:56
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.style.Style;
import be.devine.cp3.vo.TitleElementVO;

import starling.text.TextField;

//TODO: Thomas: titel element opmaken (text in tekstveld, juiste kleur, eventueel al de properties aanmaken in appModel voor accentkleur)
public class TitleElement extends Element{
    public function TitleElement(titleElementVO:TitleElementVO) {
        super (titleElementVO);
        var t:TextField = new TextField(900, 50, titleElementVO.title, Style.FONTBOLD , 72, titleElementVO.color, true);
        t.vAlign = "top";
        t.border = true;
        addChild(t);
    }
}
}
