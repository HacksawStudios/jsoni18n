package;

import haxe.unit.TestCase;
import jsoni18n.I18n;

class TrTestCase extends TestCase
{
    var i18n : I18n;

    override public function setup() : Void
    {
        var json : String = '{
            "welcome": {
                "hello": "Hoy!",
                "subtitle": "Welcome, :name!",
                "content": {
                    "main": "Le contenu principal devrait être plus long, mais vous saisissez l\'idée.",
                    "side": "Some useful side notes to shine in society."
                }
            },
            "news": {
                "list": { "0": "Nothing to display.", "1": "Only one new item.", "_": ":_ new items." }
            },
            "title": "jsoni18n tests"
        }';
        i18n = new I18n();
        i18n.loadFromString(json);
    }

    public function testBasic() : Void
    {
        assertEquals("jsoni18n tests", i18n.tr("title"));
    }

    public function testUnknown() : Void
    {
        assertEquals("brouzoufs", i18n.tr("brouzoufs"));
    }

    public function testDepth() : Void
    {
        assertEquals("Hoy!", i18n.tr("welcome/hello"));
    }

    public function testWrongDepth() : Void
    {
        assertEquals("title/lol", i18n.tr("title/lol"));
    }

    public function testWrongType() : Void
    {
        assertEquals("welcome/content", i18n.tr("welcome/content"));
    }

    public function testVar() : Void
    {
        assertEquals("Welcome, Nekith!", i18n.tr("welcome/subtitle", [ "name" => "Nekith" ]));
    }

    public function testPlur() : Void
    {
        assertEquals("27 new items.", i18n.tr("news/list", [ "_" => 27 ]));
        assertEquals("Nothing to display.", i18n.tr("news/list", [ "_" => 0 ]));
        assertEquals("Only one new item.", i18n.tr("news/list", [ "_" => 1 ]));
    }

    public function testWrongTypePlur() : Void
    {
        assertEquals("news/list", i18n.tr("news/list"));
    }

    public function testUtf() : Void
    {
        assertEquals("Le contenu principal devrait être plus long, mais vous saisissez l\'idée.", i18n.tr("welcome/content/main"));
    }
}
