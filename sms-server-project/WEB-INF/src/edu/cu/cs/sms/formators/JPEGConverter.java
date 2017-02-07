/* 
 * Copyright 2002-2005 Boulder Learning Technologies Lab & American Association for the Advancement of Science, 
 * DLC-1B20, Department of Computer Science, University of Colorado at Boulder,
 * CO-80309, Tel: 303-492-0916, email: fahmad@colorado.edu
 * 
 * This file is part of the Concept Map Service Software Project.
 * 
 * The Concept Map Service Project is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 * 
 * The Concept Map Service OAI Project is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with The Concept Map Service System; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 * 
 * Author: Faisal Ahmad
 * Date  : Sept 14, 2005
 * email : fahmad@colorado.edu
 */

package edu.cu.cs.sms.formators;

import java.io.ByteArrayOutputStream;
import java.io.StringReader;
import java.util.Date;

import org.apache.batik.transcoder.SVGAbstractTranscoder;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.batik.transcoder.XMLAbstractTranscoder;
import org.apache.batik.transcoder.image.JPEGTranscoder;
import org.apache.batik.transcoder.image.PNGTranscoder;
import org.apache.commons.pool.KeyedObjectPool;

import edu.cu.cs.sms.ExtendedActionServlet;
import edu.cu.cs.sms.Database.SMSResultSet;
import edu.cu.cs.sms.Exceptions.IncorrectHashValueException;
import edu.cu.cs.sms.xml.GenerateXML;

public class JPEGConverter implements GenerateXML {
    XMLAbstractTranscoder t = new JPEGTranscoder();
    private float imageScale = 1.0f;
    
    
    public String getFormat() {
        return "JPEG";
    }
    
    public void setImageScale(float scale){
    	this.imageScale = scale;
    }
    
    public byte[] populate(SMSResultSet data) throws Exception {
		
        KeyedObjectPool pTemp 	= (KeyedObjectPool) ExtendedActionServlet.cxt.getAttribute("dissPool");
        Object tempFormat 		= ExtendedActionServlet.cxt.getAttribute("SVG");
        GenerateXML gTemp 		= (GenerateXML) pTemp.borrowObject(tempFormat);
        String inter 			= null;
        boolean exception		= false;

        try
        {
        	inter = new String(gTemp.populate(data));
        }
        catch(Exception exp)
        {
        	exception = true;
        }
        finally
        {
        	pTemp.returnObject(tempFormat,gTemp);
        	
        	if(exception)
        		throw new Exception("SVG generator chocked");
        }

        int start = inter.indexOf("width=\"") + "width=\"".length();
        int end = inter.indexOf("\"", start);
        
        String sWidth = inter.substring(start, end);
        double nWidth = Float.parseFloat(sWidth) + 140.0;
        
        if(nWidth < 650)
        	nWidth = 650;
        
        String replacedString = "width=\""+sWidth+"\"";
        String replacer	= "width=\""+nWidth+"\"";
        
        inter = inter.replaceFirst(replacedString, replacer);

        start = inter.indexOf("height=\"") + "height=\"".length();
        end = inter.indexOf("\"", start);
        String height = inter.substring(start, end);

        TranscoderInput input = new TranscoderInput(new StringReader(inter));
        ByteArrayOutputStream imageStream = new ByteArrayOutputStream();
        TranscoderOutput output = new TranscoderOutput(imageStream);
		
		// May be a JPEGTranscoder or PNGTranscoder or PDFTranscoder
		if(t instanceof JPEGTranscoder) {
			t.addTranscodingHint(JPEGTranscoder.KEY_QUALITY, new Float(1));
		}
        t.addTranscodingHint(SVGAbstractTranscoder.KEY_HEIGHT, new Float(Float.parseFloat(height)*data.getImageScale()));
        t.addTranscodingHint(SVGAbstractTranscoder.KEY_WIDTH, new Float(nWidth*data.getImageScale()));

        try
        {
        	t.transcode(input, output);
        }
        catch(Exception exp)
        {
        	throw new IncorrectHashValueException(); 
        }

        return imageStream.toByteArray();
    }

    public boolean isBinary() {
        return true;
    }

    public String mimeType() {
        return "image/jpeg";
    }

    public XMLAbstractTranscoder getT() {
        return t;
    }

    public void setT(XMLAbstractTranscoder t) {
        this.t = t;
    }
	
	public Date getLastModifiedDate() {
		return new Date(); 
	}	
}
