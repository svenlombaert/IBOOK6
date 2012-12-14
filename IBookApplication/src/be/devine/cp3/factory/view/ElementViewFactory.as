/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:03
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.factory.view {
import be.devine.cp3.view.elements.BackgroundPhotoElement;
import be.devine.cp3.view.elements.BodyTextElement;
import be.devine.cp3.view.elements.IntroTextElement;
import be.devine.cp3.view.elements.LinkElement;
import be.devine.cp3.view.elements.TitleElement;
import be.devine.cp3.vo.BackgroundPhotoElementVO;
import be.devine.cp3.vo.BodyTextElementVO;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.IntroTextElementVO;
import be.devine.cp3.vo.LinkElementVO;
import be.devine.cp3.vo.TitleElementVO;

public class ElementViewFactory {
    public static function createFromVO(elementVO:ElementVO) {
        //TODO: checken op verschillende VO en juiste view klasse returnen
        if(elementVO is BodyTextElementVO){
            return new BodyTextElement(elementVO as BodyTextElementVO);
        }
        if(elementVO is IntroTextElementVO){
            return new IntroTextElement(elementVO as IntroTextElementVO);
        }
        if(elementVO is TitleElementVO){
            return new TitleElement(elementVO as TitleElementVO);
        }
        if(elementVO is LinkElementVO) {
            return new LinkElement(elementVO as LinkElementVO);
        }
        /*if (elementVO is BackgroundPhotoElementVO) {
            return new BackgroundPhotoElement(elementVO as BackgroundPhotoElementVO);
        }*/
        return null;
    }
}
}
