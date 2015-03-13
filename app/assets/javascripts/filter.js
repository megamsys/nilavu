jQuery.fn.jcOnPageFilter = function(a) {
    a = jQuery.extend({
        animateHideNShow: false,
        focusOnLoad: false,
        highlightColor: "yellow",
        textColorForHighlights: "#000000",
        caseSensitive: false,
        hideNegatives: false,
        parentLookupClass: "jcorgFilterTextParent",
        rootparentLookupClass: "jcorgFilterTextRootParent",
        childBlockClass: "jcorgFilterTextChild"
    }, a);
    jQuery.expr[":"].icontains = function(a, b, c) {
        return jQuery(a).text().toUpperCase().indexOf(c[3].toUpperCase()) >= 0
    };
    if (a.focusOnLoad) {
        jQuery(this).focus()
    }
    var b = /(<span.+?>)(.+?)(<\/span>)/g;
    var c = "g";
    if (!a.caseSensitive) {
        b = /(<span.+?>)(.+?)(<\/span>)/gi;
        c = "gi"
    }
    return this.each(function() {
        jQuery(this).keyup(function(d) {
            if (d.which && d.which == 13 || d.keyCode && d.keyCode == 13) {
                return false
            } else {
                var e = jQuery(this).val();
                if (e.length > 0) {
                    if (a.hideNegatives) {
                        if (a.animateHideNShow) {
                            jQuery("." + a.parentLookupClass).stop(true, true).fadeOut("slow")
                            jQuery("." + a.rootparentLookupClass).stop(true, true).fadeOut("slow")
                        } else {
                            jQuery("." + a.parentLookupClass).stop(true, true).hide()
                            jQuery("." + a.rootparentLookupClass).stop(true, true).hide()
                        }
                    }
                    var f = "icontains";
                    if (a.caseSensitive) {
                        f = "contains"
                    }
                   // jQuery.each(jQuery("." + a.childBlockClass), function(a, c) {
                   //     console.log(jQuery(c).html(jQuery(c).html()));
                    //    jQuery(c).html(jQuery(c).html().replace(new RegExp(b), "$2"))
                      //  console.log(jQuery(c).html(jQuery(c).html().replace(new RegExp(b), "$2")));
                   // });
                  // console.log(jQuery("." + a.childBlockClass + ":" + f + "(" + e + ")"));
                    jQuery.each(jQuery("." + a.childBlockClass + ":" + f + "(" + e + ")"), function(b, d) {
                        console.log(d);
                        if (a.hideNegatives) {
                            if (a.animateHideNShow) {
                                console.log(jQuery(d).parent().parent().parent().parent().parent().parent().parent());
                                jQuery(d).parent().parent().parent().parent().parent().parent().parent().stop(true, true).fadeIn("slow")
                                jQuery(d).parent().stop(true, true).fadeIn("slow")
                            } else {
                            console.log(jQuery(d).parent().parent().parent().parent().parent().parent().parent());
                                jQuery(d).parent().parent().parent().parent().parent().parent().parent().stop(true, true).show()
                                jQuery(d).parent().stop(true, true).show()
                            }
                        }
                       // var f = jQuery(d).html();
                      //  jQuery(d).html(f.replace(new RegExp(e, c), function(b) {
                       //     return ["<span style='background:" + a.highlightColor + ";color:" + a.textColorForHighlights + "'>", b, "</span>"].join("")
                       // }))
                    })
                } else {
                    jQuery.each(jQuery("." + a.childBlockClass), function(a, c) {
                        var d = jQuery(c).html().replace(new RegExp(b), "$2");
                        jQuery(c).html(d)
                    });
                    if (a.hideNegatives) {
                        if (a.animateHideNShow) {
                            jQuery("." + a.parentLookupClass).stop(true, true).fadeIn("slow")
                            jQuery("." + a.rootparentLookupClass).stop(true, true).fadeIn("slow")
                        } else {
                            jQuery("." + a.parentLookupClass).stop(true, true).show()
                            jQuery("." + a.rootparentLookupClass).stop(true, true).show()
                        }
                    }
                }
            }
        })
    })
}
