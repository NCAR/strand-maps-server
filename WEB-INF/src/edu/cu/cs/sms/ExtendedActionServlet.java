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
 * The Concept Map Service Project is distributed in the hope that it will be
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

package edu.cu.cs.sms;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.Date;
import java.util.PropertyResourceBundle;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.pool.impl.GenericKeyedObjectPool;
import org.apache.struts.action.ActionServlet;

import edu.cu.cs.sms.Database.QueryEngine;
import edu.cu.cs.sms.Exceptions.CachePropertyException;
import edu.cu.cs.sms.Exceptions.DatabaseClassNotFoundException;
import edu.cu.cs.sms.Exceptions.DatabaseInstantiationException;
import edu.cu.cs.sms.Exceptions.DissiminatorClassNotFoundException;
import edu.cu.cs.sms.Exceptions.DissiminatorInstantiationException;
import edu.cu.cs.sms.Exceptions.ObjectPoolException;
import edu.cu.cs.sms.Exceptions.PoolConfigException;
import edu.cu.cs.sms.Exceptions.ResourceBundleLoadException;
import edu.cu.cs.sms.util.DissiminatorFactory;
import edu.cu.cs.sms.util.DumpDatabase;
import edu.cu.cs.sms.util.NotificationCenter;
import edu.cu.cs.sms.util.Store;
import edu.cu.cs.sms.util.PersistentStore;
import edu.cu.cs.sms.xml.GenerateXML;
import org.apache.commons.io.FileUtils;

import org.dlese.dpc.webapps.tools.GeneralServletTools;

public class ExtendedActionServlet extends ActionServlet {
    /**
     * Comment for <code>serialVersionUID</code>
     */
    private static final long serialVersionUID = 3257854259662763827L;

    public static ServletContext cxt = null;

    private static int initObjects = 2;
	
	// Use Store for RAM cache, PersistentStore is the beginning implementation for DB-based cache: 
    public static Store iStore = null;
	//public static PersistentStore iStore = null;
	
    private PropertyResourceBundle errorCodes = null;

    private PropertyResourceBundle errorDescriptions = null;
	
    public void init() throws ServletException {
        super.init();
		cxt = getServletContext();
		
		System.out.println(cxt.getServletContextName() + " is starting at context path " + getContextPath(cxt) + ". Please wait...");
		
        try {
            this.errorCodes = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                    "edu/cu/cs/sms/ErrorCodes.properties")));

            this.errorDescriptions = new PropertyResourceBundle(
                    new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/ErrorDescriptions.properties")));

            String initO = getInitParameter("initInstances");

            if (initO != null)
                initObjects = Integer.parseInt(initO.trim());

            loadLogger();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Logger loaded");
            startNotifier();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Notification center started");
					
            System.out.println("SMS Server: Loading query engine...");
			loadQueryEngine();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Query engines loaded");
			
			System.out.println("SMS Server: Loading cache...");
			
			//iStore = startPersistentCache();
            iStore = startCache();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Cache started");
			((NotificationCenter) ExtendedActionServlet.cxt
                .getAttribute("NotificationCenter")).register(iStore);
				
			System.out.println("SMS Server: Loading CSIP schema...");		
            loadCSIPSchema();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("CSIP schema loaded");
							
            deployDatabase();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Database deployed");

            // loadNLPClasses();
            // ((Logger)ExtendedActionServlet.cxt.getAttribute("logger")).config("Natural
            // language processing classes loaded");
			
			System.out.println("SMS Server: Loading formats...");
            loadFormats();
            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .config("Dissiminator formats loaded");
        } catch (Exception exp) {
            /*
             * String expName = exp.getClass().getName();
             * 
             * System.err.println("\n\n\n"+"Exception : "+expName);
             * 
             * try { System.err.println("Error Code :
             * "+errorCodes.getString(expName)); System.err.println("Error
             * Description : "+errorDescriptions.getString(expName)); }
             * catch(MissingResourceException e){}
             * 
             */System.err.println("Error Message : " + exp.getMessage());
            System.err
                    .println("Please fix the problem and reload the Strand Map Service server"
                            + "\n\n\n");

            ((Logger) ExtendedActionServlet.cxt.getAttribute("logger"))
                    .severe(exp.getMessage());

            throw new UnavailableException(exp.getMessage());
        }
		
		System.out.println("SMS Server started...");
    }

    
    private PropertyResourceBundle getDatabasePropertyResourceBundle() throws IOException
    {
    	return new PropertyResourceBundle(
                new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/Database/database.properties")));

    }
    
    private void deployDatabase() throws UnavailableException {
        try {
            PropertyResourceBundle conf = getDatabasePropertyResourceBundle();
			
			String dbFilePath = cxt.getRealPath(conf.getString("Driver.DataFileName"));
			
			System.out.println("SMS Server: Deploying database from file located at '"+dbFilePath+"'");
			
            BufferedReader data = new BufferedReader(new FileReader(dbFilePath));
            String dataLine = data.readLine();
            StringBuffer sb = new StringBuffer();
            boolean isComment = false;

            Class.forName(conf.getString("Driver.Name").trim());

            Connection con = DriverManager.getConnection(conf.getString("Driver.URL").trim(), conf.getString("Driver.User").trim(),conf.getString("Driver.Password").trim());

            Statement stmt = con.createStatement();

            try {
                try {
                    if (conf.getString("Driver.Override").trim().equalsIgnoreCase("true"))
                        stmt.executeUpdate("drop database "
                                + conf.getString("Driver.database").trim()
                                + ";");
                } catch (SQLException exp) {
					//System.out.println("Database error: " + exp);	
                }

                stmt.executeUpdate("create database "
                        + conf.getString("Driver.database").trim() + ";");

                con = DriverManager.getConnection(conf.getString("Driver.URL")
                        .trim()
                        + conf.getString("Driver.database").trim(), conf
                        .getString("Driver.User").trim(), conf.getString(
                        "Driver.Password").trim());

                stmt = con.createStatement();
				
				int numDataLinesExecuted = 0;
				
                while (dataLine != null) {
                    dataLine = dataLine.trim();

                    if (dataLine.startsWith("/*"))
                        isComment = true;

                    if (!isComment)
                        if (!dataLine.startsWith("#")
                                && !dataLine.startsWith("--")
                                && dataLine.length() > 0) {
                            sb.append(dataLine);

                            if (dataLine.endsWith(";")) {
								try {
									stmt.executeUpdate(sb.toString());
								} catch (Exception t) {
									System.out.println("Database error reading line: '" + sb + "'");
									throw t;
								}
                                sb = new StringBuffer();
								numDataLinesExecuted++;
                            }
                        }

                    if (dataLine.endsWith("*/") || dataLine.endsWith("*/;"))
                        isComment = false;

                    dataLine = data.readLine();
                }

				System.out.println("SMS Server: Database loaded " + numDataLinesExecuted + " lines.");		

            } catch (SQLException exp) {
				System.out.println("SMS Server: Database error: " + exp);
                exp.printStackTrace();

                if (exp.getErrorCode() == 1045 || exp.getErrorCode() == 1044
                        || exp.getErrorCode() == 1007)
                    throw exp;
			} finally {
				stmt.close();
				con.close();
				data.close();	
			}
        } catch (Exception exp) {
			System.out.println("SMS Server: Database error: " + exp);
            throw new UnavailableException(exp.getMessage());
		}

    }

    /**
     * 
     */
    private void startNotifier() {
        cxt.setAttribute("NotificationCenter", new NotificationCenter());
    }

    private void loadLogger() throws SecurityException, IOException {
        // Setting the logging properties file location
        System.setProperty("java.util.logging.config.file", cxt
                .getRealPath("WEB-INF/logging.properties"));

        // Reading the custom configuration
        LogManager.getLogManager().readConfiguration();

        Logger logger = Logger.getLogger("root");
        String path = cxt.getRealPath("") + "/Log";
        Level lev = Level.OFF;
        Handler handle = null;
        File logDir = new File(path);

        // Making sure the log directory exists
        if (!logDir.exists())
            logDir.mkdir();

        // creating new file handler
        handle = new FileHandler(path + "/" + "%g-SMSLog.log.%u", Integer
                .parseInt((getInitParameter("LogFileSize"))), Integer
                .parseInt(getInitParameter("LogFileRotations")), true);
        Handler[] hls = logger.getHandlers();

        // Deleting any previous handlers
        for (int counter = 0; counter < hls.length; counter++)
            logger.removeHandler(hls[counter]);

        // setting the log detail level
        if (getInitParameter("LogLevel").equalsIgnoreCase("ALL"))
            lev = Level.ALL;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("OFF"))
            lev = Level.OFF;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("INFO"))
            lev = Level.INFO;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("FINEST"))
            lev = Level.FINEST;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("FINER"))
            lev = Level.FINER;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("CONFIG"))
            lev = Level.CONFIG;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("SEVERE"))
            lev = Level.SEVERE;
        else if (getInitParameter("LogLevel").equalsIgnoreCase("WARNING"))
            lev = Level.WARNING;

        handle.setLevel(lev);
        logger.setLevel(lev);

        // adding the newly generated file handler to logger
        logger.addHandler(handle);

        cxt.setAttribute("logger", logger);
    }

    @SuppressWarnings( { "unchecked", "unchecked" })
    private void loadQueryEngine() throws SQLException, InstantiationException,
            IllegalAccessException, ClassNotFoundException, IOException,
            FileNotFoundException, TransformerConfigurationException {
        String[] queryEngines = getInitParameter("QueryEngines").split(":");

        for (int counter = 0; counter < queryEngines.length; counter++) {
            Class dClass = null;
            QueryEngine qeTemp = null;

            try {
                dClass = Class.forName(queryEngines[counter]);
            } catch (ClassNotFoundException exp) {
                throw new DatabaseClassNotFoundException(
                        "Incorrect or missing query engine class names");
            }

            try {
                qeTemp = (QueryEngine) dClass.newInstance();
            } catch (InstantiationException exp) {
                throw new DatabaseInstantiationException(
                        "Server internal error, unable to create database classes, please check JVM/TOMCAT configurattion");
            }

            String key = qeTemp.getKey();

            loadStylesheet(qeTemp.getStylesheetLocation(), "XSLT:" + key);
            cxt.setAttribute(key, qeTemp);

        }
    }

    private void loadFormats() throws Exception {
        GenericKeyedObjectPool.Config config = new GenericKeyedObjectPool.Config();

        if (config == null)
            throw new PoolConfigException(
                    "Unable to configure object pooling class for dissiminators");

        config.maxActive = initObjects;
        config.maxIdle = 10;
        config.testWhileIdle = true;
        config.whenExhaustedAction = GenericKeyedObjectPool.WHEN_EXHAUSTED_BLOCK;

        GenericKeyedObjectPool dissiminatorsPool = new GenericKeyedObjectPool(
                new DissiminatorFactory(), config);

        if (dissiminatorsPool == null)
            throw new ObjectPoolException(
                    "Object pool creation error for dissiminator, please configure jakarta commons pooling");

        cxt.setAttribute("dissPool", dissiminatorsPool);

        String[] classNames = getInitParameter("loadClasses").split(":");
        String[] supportedFormats = new String[classNames.length];

        for (int counter = 0; counter < classNames.length; counter++) {
            Class dClass = null;
            GenerateXML gxl = null;
            try {
                dClass = Class.forName(classNames[counter]);
            } catch (ClassNotFoundException exp) {
                throw new DissiminatorClassNotFoundException(
                        "Incorrect or missing dissiminator class names");
            }

            try {
                gxl = (GenerateXML) dClass.newInstance();
            } catch (InstantiationException exp) {
                throw new DissiminatorInstantiationException(
                        "Server internal error, unable to create dissiminator classes, please check JVM/TOMCAT configurattion");
            }

            String key = gxl.getFormat();

            supportedFormats[counter] = key;

            cxt.setAttribute(key, dClass);
        }

        cxt.setAttribute("supportedFormats", supportedFormats);

        for (int counter = 0; counter < supportedFormats.length; counter++)
            for (int innerCounter = 0; innerCounter < initObjects; innerCounter++)
                dissiminatorsPool.addObject(cxt
                        .getAttribute(supportedFormats[counter]));
    }

	/*
	 * Start the cache service. This method also checks to make sure the database file didn't
	 * change. If it did it removes the cache
	 */
    private Store startCache() throws FileNotFoundException, IOException, ServletException, UnavailableException {
        PropertyResourceBundle cacheConf;
        cacheConf = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream(
                "edu/cu/cs/sms/util/Cache.properties")));

        if (cacheConf == null)
            throw new ResourceBundleLoadException(
                    "Unable to load cache.properties");
        
        
        String cacheDirectoryString = cacheConf.getString("Cache.Directory").trim();
        boolean cachePersisent = Boolean.parseBoolean(cacheConf.getString("Cache.Persistent").trim());
        Store cacheStore = new Store(cacheDirectoryString, cachePersisent);
        
        PropertyResourceBundle conf = getDatabasePropertyResourceBundle();		
		String dbFilePath = cxt.getRealPath(conf.getString("Driver.DataFileName"));
		File currentDatabaseFile = new File(dbFilePath);
		
		File databaseFileBasedOnCache = new File(cacheDirectoryString, 
				currentDatabaseFile.getName() );
		
		// If the database file in the cache directory is not the same one that is in the 
		// cache directory clear the store.
		if(!FileUtils.contentEquals(currentDatabaseFile, 
				databaseFileBasedOnCache ))
		{
			// Database has changed clear it
			cacheStore.clearStore();
			
			// Copy the new one over to the store
			FileUtils.copyFile(currentDatabaseFile, databaseFileBasedOnCache);
		}

        return cacheStore;
    }

    // This function precompiles the query translator stylesheet to improve
    // performance
    private void loadStylesheet(String stylesheetLocation, String key)
            throws TransformerConfigurationException, FileNotFoundException,
            IOException {
        TransformerFactory tFactory = TransformerFactory.newInstance();

        if (tFactory == null)
            throw new TransformerConfigurationException(
                    "Unable to create new stylesheet transformer factory, please check Xalan configuration");

        Templates templates = tFactory.newTemplates(new StreamSource(
                ExtendedActionServlet.cxt.getRealPath(stylesheetLocation)));
        Transformer transformer = templates.newTransformer();

        if (transformer == null)
            throw new TransformerConfigurationException(
                    "Unable to create new stylesheet transformer, please check Xalan configuration");

        cxt.setAttribute(key, transformer);
    }

    // This function pre-loads CSIP schema into Xerces cache to improve effiency
    // of application
    private void loadCSIPSchema() {
        System.setProperty("org.apache.xerces.xni.parser.Configuration",
                "org.apache.xerces.parsers.XMLGrammarCachingConfiguration");

        /*
         * final String SYMBOL_TABLE = Constants.XERCES_PROPERTY_PREFIX +
         * Constants.SYMBOL_TABLE_PROPERTY; final String GRAMMAR_POOL =
         * Constants.XERCES_PROPERTY_PREFIX +
         * Constants.XMLGRAMMAR_POOL_PROPERTY;
         * 
         * SymbolTable sym = null; XMLGrammarPoolImpl grammarPool = null;
         * XMLReader reader = null; XMLGrammarPreparser preparser = null; String
         * CSIPSchemaLocation = null; String CSIPNameSpace = null;
         * XMLInputSource inSchema = null; XMLParserConfiguration config = null;
         * 
         * CSIPSchemaLocation =
         * (getServletContext().getRealPath("/WEB-INF/XML/CSIP.xsd")).replaceAll("
         * ","%20");
         * 
         * grammarPool = new XMLGrammarPoolImpl(); preparser = new
         * XMLGrammarPreparser();
         * 
         * preparser.registerPreparser(XMLGrammarDescription.XML_SCHEMA,null);
         * preparser.setProperty(GRAMMAR_POOL,grammarPool);
         * preparser.setFeature("http://xml.org/sax/features/namespaces", true);
         * preparser.setFeature("http://xml.org/sax/features/validation", true);
         * preparser.setFeature("http://apache.org/xml/features/validation/schema",true);
         * 
         * inSchema = new XMLInputSource(null,CSIPSchemaLocation,null);
         * 
         * Grammar CSIPGrammar =
         * preparser.preparseGrammar(XMLGrammarDescription.XML_SCHEMA,inSchema);
         * 
         * config = new StandardParserConfiguration();
         * config.setProperty(GRAMMAR_POOL,grammarPool);
         * config.setFeature("http://xml.org/sax/features/namespaces", true);
         * config.setFeature("http://xml.org/sax/features/validation", true);
         * config.setFeature("http://apache.org/xml/features/validation/schema",true);
         * 
         * getServletContext().setAttribute("CSIPSchema", config);
         */}

    @Override
	public void destroy() {
        super.destroy();
		
		// Write the current DB to the DB file?
		boolean dumpDatabaseToFile = false;
		
		System.out.println("SMS Server shuttinng down. Please wait...");
        PropertyResourceBundle conf = null;
        try {
        	conf = new PropertyResourceBundle(new BufferedInputStream(this.getClass().getClassLoader().getResourceAsStream("edu/cu/cs/sms/Database/database.properties")));
            
			// Write the DB to file, if instructed (note that this has resulted with an empty DB file in some environments):
			if(dumpDatabaseToFile) {
				System.out.println(getServletContext().getServletContextName() + " writing database dump to file...");
				String data = DumpDatabase.dumpTableSchema(conf) + "\n" + DumpDatabase.dumpTableContent(conf);
				FileWriter dataFile = new FileWriter(cxt.getRealPath(conf.getString("Driver.DataFileName")), false);
				PrintWriter dataPrinter = new PrintWriter(dataFile);
	
				dataPrinter.print(data);
	
				dataPrinter.flush();
				dataFile.flush();
				dataPrinter.close();
				dataFile.close();
			}

            if (conf.getString("Driver.CleanUp").trim().equalsIgnoreCase("true")) {
				
				System.out.println(getServletContext().getServletContextName() + " dropping SMS database tables...");
				
                Class.forName(conf.getString("Driver.Name").trim());

                Connection con = DriverManager.getConnection(conf.getString(
                        "Driver.URL").trim(), conf.getString("Driver.User"),
                        conf.getString("Driver.Password"));

                Statement stmt = con.createStatement();

                stmt.executeUpdate("drop database "
                        + conf.getString("Driver.database").trim() + ";");

                stmt.close();
                con.close();
            }
        } catch (Exception e) 
        {
        	if(e instanceof FileNotFoundException)
        	{
        		System.err.println("Unable to save data. Access denied to file: "+conf.getString("Driver.DataFileName")+"\nPlease backup the database before restatring CMS server otherwise you will lose any changes to the database.");
        	}
        }
		System.out.println(getServletContext().getServletContextName() + " stopped.");
    }

    /* (non-Javadoc)
     * @see org.apache.struts.action.ActionServlet#destroyInternal()
     */
    @Override
    protected void destroyInternal() 
    {
        super.destroyInternal();
        
        Logger logger = Logger.getLogger("root");
        
        Handler[] handles = logger.getHandlers();
        
        for(Handler temp: handles)
            temp.close();

    }
	
    /**
     * Returns the context path for the webapp, for example '/cms1-2' or '/' for the root context.
     */	
	private String getContextPath(ServletContext servletContext) {
		try {
			String path = "/";
			String [] pathSegments = servletContext.getResource("/").getPath().split("/");
			
			if(pathSegments.length > 2)
				path += pathSegments[pathSegments.length-1];
			return path;
			
		} catch (Throwable t) {
			return null;	
		}
	}	
	
}
