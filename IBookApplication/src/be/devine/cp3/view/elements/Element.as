/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 14:44
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.vo.ElementVO;

import starling.display.Sprite;

public class Element extends Sprite {
    protected var _elementVO:ElementVO;
    public function Element(elementVO:ElementVO) {
        _elementVO = elementVO;
    }
}
}
