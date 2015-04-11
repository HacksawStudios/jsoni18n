package jsoni18n;

import haxe.Json;
#if openfl
import openfl.Assets;
#end

class I18n
{
#if openfl
  public static function loadFromFile(filename : String, ?prefix : String) : Void
  {
    loadFromString(Assets.getText(filename), prefix);
  }
#end

  public static function loadFromString(content : String, ?prefix : String) : Void
  {
    if (trads == null) {
      trads = new DynamicObject<Dynamic>();
    }
    var data : DynamicObject<Dynamic> = Json.parse(content);
    for (key in data.keys()) {
      var name : String = key;
      if (prefix != null) {
        name = prefix + name;
      }
      if (name.indexOf("/") != -1) {
        update(trads, name, data.get(key));
      } else {
        trads.set(name, data.get(key));
      }
    }
  }

  public static function tr(id : String, ?args : Map<String, String>) : String
  {
    if (trads == null) {
      return "";
    }
    if (id.indexOf("/") != -1) {
      return fetch(trads, new String(id));
    }
    return trads.get(id);
  }

  public static function remove(prefix : String) : Void
  {
  }

  public static function clear() : Void
  {
  }

  private static function update(el : DynamicObject<Dynamic>, rest : String, data : Dynamic) : Void
  {
    var pos : Int = rest.indexOf("/");
    if (pos == -1) {
      el.set(rest, data);
    } else {
      var part : String = rest.substr(0, pos);
      rest = rest.substr(pos + 1);
      var sub : DynamicObject<Dynamic> = new DynamicObject<Dynamic>();
      el.set(part, sub);
      update(sub, rest, data);
    }
  }

  private static function fetch(el : DynamicObject<Dynamic>, rest : String) : String
  {
    var pos : Int = rest.indexOf("/");
    if (pos == -1) {
      return el.get(rest);
    }
    var part : String = rest.substr(0, pos);
    rest = rest.substr(pos + 1);
    if (el.exists(part) == false) {
      return "";
    }
    return fetch(el.get(part), rest);
  }

  private static var trads : DynamicObject<Dynamic>;
}

abstract DynamicObject<T>(Dynamic<T>) from Dynamic<T>
{
  public inline function new()
  {
    this = {};
  }

  @:arrayAccess
  public inline function set(key : String, value : T) : Void
  {
    Reflect.setField(this, key, value);
  }

  @:arrayAccess
  public inline function get(key : String) : Null<T>
  {
#if js
      return untyped this[key];
#else
      return Reflect.field(this, key);
#end
  }

  public inline function exists(key : String) : Bool
  {
    return Reflect.hasField(this, key);
  }

  public inline function keys() : Array<String>
  {
    return Reflect.fields(this);
  }
}