/***********************************************************************************************************************
 *      
 *      CustomButton.vala
 * 
 *      This software is a simple experimental (and shitty) Panel.
 *      The "S" of SPanel can be either simple or shitty.
 *      That thing is my very first Gtk+ program.
 *      
 *      Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License Version 2.
 *      http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * 
 *      Purpose: 
 * 
 * 
 * 
 **********************************************************************************************************************/
namespace Panel {
    
    public class CustomButton : Gtk.EventBox {
        
        private Gtk.Image _image;
        private Gdk.Pixbuf? _pixbuf;
        private Gdk.Pixbuf? _pixbufhigh;
        
        public bool create (string icon, int size) {
        
            Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
            _pixbuf = icon_theme.load_icon (icon, size, 0);
            _pixbufhigh = _pixbuf.copy ();
            
            _pixbufhigh.saturate_and_pixelate (_pixbufhigh, (float)0.5, false);
            _image = new Gtk.Image.from_pixbuf (_pixbufhigh);

            this.enter_notify_event.connect ( (event) => {
                _image.set_from_pixbuf (_pixbuf);
                return false;
            });
            this.leave_notify_event.connect ( (event) => {
                _image.set_from_pixbuf (_pixbufhigh);
                return false;
            });
            
            this.add (_image);
            
            return true;
        }
    }
}



