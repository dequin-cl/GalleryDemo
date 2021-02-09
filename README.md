# GalleryDemo

Sample app to display pictures grabbed from a URL. The thumbnails are displayed on a Collection, with custom Layouts for iPhone and a separated one for iPad. From the collection you can pick a picture and see it alone on the display.

## Support

Minimun iOS version is 11.0

## Architecture

Uses MVVM as the code architecture

Uses Decodable to parse a JSON response from the REST API

## Collection Layout

Implements two layouts, Mosaic (based on the Apple demo code from WWDC) and Grid (based on the work by Astemir Eleev).

Mosaic is used on the iPhone while Grid will be used on iPad.

## Project Structure

The files for the project are sorted regarding its posible usage. Those object that may be used on the app as a whole are under the root on a folder that declares its purpouse.

The views are associated with an Scene, in this appliction there are two: Images and Image Details.


