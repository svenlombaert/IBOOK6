/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 13:49
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.factory.vo {
import be.devine.cp3.vo.PageVO;

public class PageVOFactory {

    public static function createFromXML(pageXML:XML, pageNumber:uint) {
        //TODO: kijken hoe xml zo makkelijk mogelijk te parsen

        var pageVO:PageVO = new PageVO();

        for each(var elementXML:XML in pageXML.element){
            pageVO.elements.push(ElementVOFactory.CreateFromXML(elementXML));
            pageVO.pageNumber = pageNumber;
        }
        return pageVO;

    }
}
}
