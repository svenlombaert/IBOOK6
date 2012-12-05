/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 14:05
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.factory.vo {
import be.devine.cp3.vo.BackgroundPhotoElementVO;
import be.devine.cp3.vo.BodyTextElementVO;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.IntroTextElementVO;
import be.devine.cp3.vo.TitleElementVO;

public class ElementVOFactory {
    public static function CreateFromXML(elementXML:XML) {
        //TODO: alle cases toevoegen, juiste properties meegeven aan elementVO
        switch("" + elementXML.@type){
            case "title": return createTitleElementVO(elementXML); break;
            case "backgroundPhoto": return createBackgroundPhotoElementVO(elementXML); break;
            case "intro": return createIntroTextElementVO(elementXML); break;
            case "body": return createBodyElementVO(elementXML); break;
        }
        return null;
    }

    public static function createTitleElementVO(elementXML:XML):TitleElementVO {
        var elementVO:TitleElementVO = new TitleElementVO();
        elementVO.type = elementXML.@type;
        elementVO.title = elementXML;
        return elementVO;
    }

    public static function createBackgroundPhotoElementVO(elementXML:XML):BackgroundPhotoElementVO {
        var elementVO:BackgroundPhotoElementVO = new BackgroundPhotoElementVO();
        return elementVO;
    }

    public static function createIntroTextElementVO(elementXML:XML):IntroTextElementVO {
        trace('AANMAKEN INTRO TEXT VO');
        var elementVO:IntroTextElementVO = new IntroTextElementVO();
        elementVO.text = elementXML;
        return elementVO;
    }

    public static function createBodyElementVO(elementXML:XML):BodyTextElementVO {
        var elementVO:BodyTextElementVO = new BodyTextElementVO();
        elementVO.text = elementXML;
        return elementVO;
    }
}
}
