/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 12:22
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.vo {
public class PageVO {

    public var title:String = "";
    public var textfields:Vector.<String> = Vector.<String>([]);
    public var textfieldpositions:Vector.<int> = Vector.<int>([]);
    public var links:Vector.<String> = Vector.<String>([]);
    public var photo:String = "";

    public function PageVO() {
    }
}
}
