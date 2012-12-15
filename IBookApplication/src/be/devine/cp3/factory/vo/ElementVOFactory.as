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
import be.devine.cp3.vo.IntroTextElementVO;
import be.devine.cp3.vo.LinkElementVO;
import be.devine.cp3.vo.SubTitleElementVO;
import be.devine.cp3.vo.TitleElementVO;

public class ElementVOFactory {
    public static function CreateFromXML(elementXML:XML) {
        //TODO: alle cases toevoegen, juiste properties meegeven aan elementVO
        switch("" + elementXML.@type){
            case "title": return createTitleElementVO(elementXML); break;
            case "subtitle": return createSubTitleElementVO(elementXML); break;
            case "backgroundPhoto": return createBackgroundPhotoElementVO(elementXML); break;
            case "intro": return createIntroTextElementVO(elementXML); break;
            case "body": return createBodyElementVO(elementXML); break;
            case "link": return createLinkElementVO(elementXML); break;
        }
        return null;
    }

    private static function createLinkElementVO(elementXML:XML): LinkElementVO{
        var elementVO:LinkElementVO = new LinkElementVO();
        elementVO.type = elementXML.@type;
        elementVO.text = elementXML;
        elementVO.xPos = elementXML.@x;
        elementVO.yPos = elementXML.@y;
        return elementVO;
    }

    private static function createSubTitleElementVO(elementXML:XML): SubTitleElementVO{
        var elementVO:SubTitleElementVO = new SubTitleElementVO();
        elementVO.type = elementXML.@type;
        elementVO.subtitle = elementXML;
        return elementVO;
    }

    public static function createTitleElementVO(elementXML:XML):TitleElementVO {
        var elementVO:TitleElementVO = new TitleElementVO();
        elementVO.type = elementXML.@type;
        elementVO.title = elementXML;
        return elementVO;
    }

    public static function createBackgroundPhotoElementVO(elementXML:XML):BackgroundPhotoElementVO {
        var elementVO:BackgroundPhotoElementVO = new BackgroundPhotoElementVO();
        elementVO.path = elementXML;
        return elementVO;
    }

    public static function createIntroTextElementVO(elementXML:XML):IntroTextElementVO {
        var elementVO:IntroTextElementVO = new IntroTextElementVO();
        elementVO.text = elementXML;
        elementVO.xPos = elementXML.@x;
        elementVO.yPos = elementXML.@y;
        return elementVO;
    }

    public static function createBodyElementVO(elementXML:XML):BodyTextElementVO {
        var elementVO:BodyTextElementVO = new BodyTextElementVO();
        elementVO.text = elementXML;
        elementVO.xPos = elementXML.@x;
        elementVO.yPos = elementXML.@y;
        return elementVO;
    }
}
}
