package utils;

import java.lang.reflect.Type;

import play.Logger;

import flexjson.ObjectBinder;
import flexjson.ObjectFactory;
import flexjson.transformer.AbstractTransformer;
import flexjson.transformer.DateTransformer;
import flexjson.transformer.Transformer;

public class NullableDateTransformer extends AbstractTransformer implements ObjectFactory, Transformer {
    
    private DateTransformer dateTransformer;
    
    public NullableDateTransformer(String string) {
        dateTransformer = new DateTransformer(string);
    }

    @Override
    public Object instantiate(ObjectBinder arg0, Object arg1, Type arg2, Class arg3) {
        try {
            return dateTransformer.instantiate(arg0, arg1, arg2, arg3);
        } catch(Exception e) {
            return null;
        }
    }

    @Override
    public void transform(Object arg0) {
        if(arg0 == null) {
            getContext().writeQuoted("");
        } else {
            dateTransformer.transform(arg0);
        }
    }
}
