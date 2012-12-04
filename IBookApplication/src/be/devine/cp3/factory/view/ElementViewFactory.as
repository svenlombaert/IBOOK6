/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:03
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.factory.view {
import be.devine.cp3.view.elements.BodyTextElement;
import be.devine.cp3.vo.BodyTextElementVO;
import be.devine.cp3.vo.ElementVO;

public class ElementViewFactory {
    public static function createFromVO(elementVO:ElementVO) {
        //TODO: checken op verschillende VO en juiste view klasse returnen
        if(elementVO is BodyTextElementVO){
            return new BodyTextElement(elementVO as BodyTextElementVO);
        }
        return null;
    }
}
}
