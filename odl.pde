/*
 * Example inspired by the earlier tutorial by blprnt
 * See http://twitter4j.org/javadoc/ for the in-depth
 * documentation about the many thing you can do with
 * the twitter4j library
 */
import gohai.simpletweet.*;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.TwitterException;
import twitter4j.User;

import twitter4j.conf.*;
 import twitter4j.json.*;
 
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
 import twitter4j.*;
 

 

import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.Rectangle;
 import javax.imageio.ImageIO;
 import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;

import processing.awt.PSurfaceAWT;
SimpleTweet simpletweet;
ArrayList<Status> tweets;
PImage logo ,avatar;



import controlP5.*;
boolean update=true,sendi=true,send=true;
ControlP5 cp5;
Textarea myTextarea;
Robot robot;
Status status;
PImage screenshot;   PSurfaceAWT.SmoothCanvas smoothCanvas;
void setup() {
  size(400, 200);surface.setResizable(true);surface.setAlwaysOnTop(true);  
/* PSurfaceAWT   awtSurface = (PSurfaceAWT)surface;
    PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
    smoothCanvas.getFrame().setAlwaysOnTop(true);
    smoothCanvas.getFrame().removeNotify();
    smoothCanvas.getFrame().setUndecorated(true);
     smoothCanvas.getFrame().setLocation(0, 0);
    smoothCanvas.getFrame().addNotify();*/
  //frameRate(0.5);
  
  logo=loadImage("a.png");
  simpletweet = new SimpleTweet(this);

  /*
   * Create a new Twitter app on https://apps.twitter.com/
   * then go to the tab "Keys and Access Tokens"
   * copy the consumer key and secret and fill the values in below
   * click the button to generate the access tokens for your account
   * copy and paste those values as well below
   */
  simpletweet.setOAuthConsumerKey("r37IDbBi7eTi496aIfF7QUOuG");
  simpletweet.setOAuthConsumerSecret("zLye1GkDqhzEw9SPzYCW8aP23OsYQO4TVb46biTz9Koy8SqTSZ");
  simpletweet.setOAuthAccessToken("837061317890564098-3kd4t6zokLqG1hs6nImlLdzSE8fYbaz");
  simpletweet.setOAuthAccessTokenSecret("7KBFyp9ZT9K8TmKHMlgwUq0sE9awgTm39a7ly3qAhzaAL");

  tweets = search("#3d");
 cp5 = new ControlP5(this);
  // create a new button with name 'buttonA'
  cp5.addButton("UUpdate").setLabel("Update")
     .setValue(0)
     .setPosition(10,80)
     .setSize(200,19)
     ;
    cp5.addButton("Ssend").setLabel("send a a screenshot ")
     .setValue(0)
     .setPosition(10,100)
     .setSize(200,19)
     ;
  cp5.addButton("Ssendt").setLabel("send a tweet")
     .setValue(0)
     .setPosition(10,130)
     .setSize(200,19)
     ;
     
     cp5.addTextfield("input").setLabel("")
     .setPosition(10,150)
     .setSize(200,40)
     .setFont(createFont("arial",20 ))
     .setFocus(true)
     .setColor(color(255,0,0))
     
     
     ;
           
      cp5.addTextfield("tag").setLabelVisible(false).setLabel("")
     .setPosition(250,10)
     .setSize(100,40)
     .setFont(createFont("arial",20 ))
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
     
  myTextarea = cp5.addTextarea("txt")
                  .setPosition(230,50)
                  .setSize(220,200)
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  .setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
  myTextarea.setText("...");
    
  cp5.addSlider("changeWidth")
     .setRange(10,250)
     .setValue(130)
     .setPosition(10,60)
     .setSize(100,10)
     ;
     
  cp5.addSlider("changeHeight")
     .setRange(10,250)
     .setValue(130)
     .setPosition(10,50)
     .setSize(100,10)
     ;
sendi=true;
send=true;
cp5.get(Textfield.class,"tag").setValue("#kill");
}

Status current ;
void draw() {
  background(0);  image(logo,0,0,50,50);
  if(update){   tweets = search("#"+cp5.get(Textfield.class,"tag").getText());
current = tweets.get(frameCount % (tweets.size()));}update =false;
   if(!update){
 // 
     String message = current.getText();
  User user = current.getUser();
  String username = user.getScreenName();
   myTextarea.setText  (message + "by @" + username);//text(message + "by @" + username, 0, height/2);
avatar=   loadImage( user.getProfileImageURL());
 
 }
 image(avatar,50,0,50,50);
 fill(125);
noStroke();

 
 if(!sendi){ screenshot();String tweet = simpletweet.tweetImage(screenshot, cp5.get(Textfield.class,"input").getText()+"#TwitterBot");}sendi =true;
 
  if(!send){ println("succes" );
  simpletweet.tweet(">>> "+cp5.get(Textfield.class,"input").getText());
       }send =true;
 
}

 
  
 void screenshot() {
  try {
    screenshot = new PImage(new Robot().createScreenCapture(new Rectangle(0, 0, displayWidth, displayHeight)));
  } catch (AWTException e) { }
}
public void UUpdate(boolean theValue) {
  println("a button event send image: "+theValue);
 update=true;
}
public void Ssend(boolean theValue2) {
  println("a button event from send: "+theValue2);
 sendi=false;
}

public void Ssendt(boolean theValue3) {
  println("a button event from send: "+theValue3);
 send=false;
}

ArrayList<Status> search(String keyword) {
  // request 100 results
  Query query = new Query(keyword);
  query.setCount(100);

  try {
    QueryResult result = simpletweet.twitter.search(query);
    ArrayList<Status> tweets = (ArrayList)result.getTweets();
    // return an ArrayList of Status objects
   return tweets;
  } catch (TwitterException e) {
    println(e.getMessage());
    return new ArrayList<Status>();
  }
}


void changeWidth(int theValue) {
  myTextarea.setWidth(theValue);
}

void changeHeight(int theValue) {
  myTextarea.setHeight(theValue);
}
