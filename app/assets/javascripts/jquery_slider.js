var mct1_Options = {
  sliderId: "mcts1",
  direction: "horizontal",
  scrollInterval: 1400,
  scrollDuration: 800,
  hoverPause: true,
  autoAdvance: true,
  scrollByEachThumb: true,
  circular: true,
  largeImageSlider: null,
  inSyncWithLargeImageSlider: true,
  license: "mylicense"
};
/* Menucool jQuery Slider v2013.3.18. Copyright www.menucool.com */
(function (a) {
  var c = new b(mct1_Options);

  function b(f) {
    var k = "length",
      j = "className",
      P = function (a, c) {
        var b = a[k];
        while (b--)
          if (a[b] === c) return true;
        return false
      }, Q = function (b, a) {
        return P(b[j].split(" "), a)
      }, K = function (a, b) {
        if (!Q(a, b))
          if (a[j] == "") a[j] = b;
          else a[j] += " " + b
      }, J = function (a, b) {
        var c = new RegExp("(^| )" +
          b + "( |$)");
        a[j] = a[j].replace(c, "$1");
        a[j] = a[j].replace(/ $/, "")
      }, D = function (b, c) {
        var a = null;
        if (typeof b.currentStyle !=
          "undefined") a = b.currentStyle;
        else a = document.defaultView
          .getComputedStyle(b, null);
        return a[c]
      }, r = "largeImageSlider",
      u = "appendChild",
      E =
        "inSyncWithLargeImageSlider",
      v = function (d) {
        var a = d.childNodes,
          c = [];
        if (a)
          for (var b = 0, e = a[k]; b <
            e; b++) a[b].nodeType ==
            1 && c.push(a[b]);
        return c
      }, U = function (b, c) {
        var a = c == 0 ? b.nextSibling :
          b.firstChild;
        while (a && a.nodeType != 1) a =
          a.nextSibling;
        return a
      }, h = "style",
      o = "offsetTop",
      n = "offsetLeft",
      s = "offsetHeight",
      w = "offsetWidth",
      z = "onmouseover",
      y = "onmouseout";

    function O() {
      var c = 50,
        b = navigator.userAgent,
        a;
      if ((a = b.indexOf("MSIE ")) != -
        1) c = parseInt(b.substring(a +
        5, b.indexOf(".", a)));
      return c
    }
    var L = O() < 8,
      T = ["$1$2$3", "$1$2$3",
        "$1$24", "$1$23", "$1$22"
      ];

    function N(b) {
      var a = [],
        c = b[k];
      while (c--) a.push(String.fromCharCode(
        b[c]));
      return a.join("")
    }
    var b = {
      b: 0,
      a: 0,
      c: 0,
      d: 0,
      e: 1,
      f: 0
    }, i, d, c, l, e, g, C, A, m, p,
        q, t, B, x, M = function (a) {
          l = a;
          c = [];
          this.c()
      }, H = function () {
        i = f.direction == "vertical" ?
          0 : 1;
        d = {
          a: f.license,
          c: f.scrollInterval,
          b: f.autoAdvance,
          d: f.scrollByEachThumb,
          f: f.circular
        };
        A && A.b()
      }, R = document,
      S = [
        /(?:.*\.)?(\w)([\w\-])[^.]*(\w)\.[^.]+$/,
        /.*([\w\-])\.(\w)(\w)\.[^.]+$/,
        /^(?:.*\.)?(\w)(\w)\.[^.]+$/,
        /.*([\w\-])([\w\-])\.com\.[^.]+$/,
        /^(\w)[^.]*(\w)+$/
      ],
      G = function (b) {
        var a = document.createElement(
          "div");
        if (b) a[j] = b;
        a[h].display = "block";
        return a
      }, F = function (b) {
        var a = document.createElement(
          "a");
        a[j] = b;
        return a
      };
    M.prototype = {
      c: function () {
        g = G(0);
        g[h][i ? "width" : "height"] =
          "99999px";
        g[h].position = "absolute";
        e = G(0);
        e[u](g);
        e[h].position = "relative";
        e[h].overflow = "hidden";
        var x = l[w] - parseInt(D(l,
          "paddingLeft") || 0) -
          parseInt(D(l,
            "paddingRight") || 0),
          t = l[s] - parseInt(D(l,
            "paddingTop") || 0) -
            parseInt(D(l,
              "paddingBottom") || 0);
        e[h].width = x + "px";
        e[h].height = t + "px";
        if (!i) {
          e[h].height = l[s] + "px";
          l[h].height = "auto"
        }
        l.insertBefore(e, l.firstChild);
        for (var m = v(l), a, z, B, d =
            1, y = m[k]; d < y; d++) {
          a = G("item");
          m[d][h].display = "block";
          a[u](m[d]);
          if (i) {
            a[h].cssFloat = "left";
            a[h].styleFloat = "left"
          }
          if (f[r]) {
            a[h].cursor = "pointer";
            a.onclick = function () {
              if (f[E]) {
                b.b = this.i;
                A.g(1, 1)
              }
              else f[r].displaySlide(
                this.i, 1, 0)
            }
          }
          c.push(g[u](a));
          c[c[k] - 1].i = d - 1
        }
        b.a = c[k];
        if (i) p = c[0][n];
        else {
          p = D(c[0], "marginTop");
          if (p == "auto" || !p) p =
            0;
          else p = parseInt(p)
        } if (c[k] > 1) var q = i ? c[
          1][n] - c[0][n] - c[0][n] -
          c[0][w] : c[1][o] - c[0][o] -
          c[0][s];
        var j = c[c[k] - 1];
        C = i ? j[n] + j[w] + q : j[o] +
          j[s] + q;
        g[h][i ? "width" : "height"] =
          C + "px";
        this.b();
        l[h].backgroundImage = "none"
      },
      b: function () {
        var a = this.l();
        if (a[0]) {
          if (q == null) a[1].f();
          else {
            B[j] = d.b ? "navPause" :
              "navPlay";
            q[j] = "navPrev";
            t[j] = "navNext"
          }!d.f && this.r();
          if (d.b) m = setTimeout(
            function () {
              a[1].d()
            }, d.c);
          if (f.hoverPause) {
            e[z] = function () {
              b.d = 1;
              clearTimeout(m);
              m = null
            };
            e[y] = function () {
              b.d = 0;
              if (m == null && !b.c &&
                d.b) {
                window.clearTimeout(m);
                m = null;
                m = setTimeout(
                  function () {
                    a[1].d()
                  }, d.c / 2)
              }
            };
            if (q) {
              t[z] = q[z] = e[z];
              t[y] = q[y] = e[y]
            }
          }
          else e[z] = e[y] = function () {}
        }
        if (f[r]) {
          f[r].getElement()[z] = e[z];
          f[r].getElement()[y] = e[y];
          f[E] && f[r].getAuto() && f[
            r].changeOptions({
            autoAdvance: false
          })
        }
      },
      e: function () {
        b.c = 0;
        clearTimeout(m);
        m = null;
        if (d.f) this.m();
        else {
          this.r();
          if (!b.e) return
        }
        var a = this;
        if (!b.d && d.b) m =
          setTimeout(function () {
            a.d()
          }, d.c)
      },
      d: function () {
        var a = this.j();
        if (a != null) {
          b.b = a;
          this.g(0, 1)
        }
      },
      g: function (j, k) {
        b.c = 1;
        d.d && this.setActiveNav();
        var h = {
          duration: f.scrollDuration,
          onComplete: function () {
            A.e()
          }
        };
        if (i) var e = {
          left: p - c[b.b][n] + "px"
        };
        else if (L) e = {
          top: p - c[b.b][o] + "px"
        };
        else e = {
          top: -c[b.b][o] + "px"
        };
        a(g).animate(e, h.duration, h
          .onComplete);
        f[r] && (f[E] || j) && f[r].displaySlide(
          b.b, 1, k)
      },
      f: function () {
        var c = this;
        if (d.d) {
          x = document.createElement(
            "div");
          x[j] = "navBullets";
          for (var f = [], a = 0; a <
            b.a; a++) f.push(
            "<a rel='" + a + "'></a>"
          );
          x.innerHTML = f.join("");
          for (var e = v(x), a = 0; a <
            b.a; a++) {
            if (a == b.b) e[a][j] =
              "active";
            e[a].onclick = function () {
              if (this[j] == "active")
                return 0;
              if (b.c) return 0;
              c.h(parseInt(this.getAttribute(
                "rel")))
            }
          }
          l[u](x)
        }
        q = F("navPrev");
        q.setAttribute(
          "onselectstart",
          "return false");
        q.onclick = function () {
          c.To(1)
        };
        l[u](q);
        B = F(d.b ? "navPause" :
          "navPlay");
        B.setAttribute(
          "onselectstart",
          "return false");
        B.setAttribute("title", d.b ?
          "Pause" : "Play");
        B.onclick = function () {
          window.clearTimeout(m);
          m = null;
          (d.b = !d.b) && c.d();
          this[j] = d.b ? "navPause" :
            "navPlay";
          this.setAttribute("title",
            d.b ? "Pause" : "Play")
        };
        l[u](B);
        t = F("navNext");
        t.setAttribute(
          "onselectstart",
          "return false");
        t.onclick = function () {
          c.To(0)
        };
        l[u](t)
      },
      setActiveNav: function () {
        if (x) {
          var c = v(x),
            a = c[k];
          while (a--)
            if (a == b.b) c[a][j] =
              "active";
            else c[a][j] = ""
        }
      },
      i: function (a, d) {
        var c = function (b) {
          var a = b.charCodeAt(0).toString();
          return a.substring(a[k] - 1)
        }, b = d.replace(S[a - 2], T[
            a - 2]).split("");
        return "b" + a + b[1] + c(b[0]) +
          c(b[2])
      },
      h: function (a) {
        b.b = this.p(a);
        window.clearTimeout(m);
        m = null;
        this.g(0, 0)
      },
      k: function (a) {
        return a.replace(
          /(?:.*\.)?(\w)([\w\-])?[^.]*(\w)\.[^.]*$/,
          "$1$3$2")
      },
      To: function (c) {
        if (b.c) return;
        if (c) {
          var a = this.o();
          if (!d.f && b.b == 0) return;
          if (a == null) return;
          else b.b = a
        }
        else {
          a = this.j();
          if (a == null) return;
          else b.b = a
        }
        window.clearTimeout(m);
        m = null;
        this.g(0, 0)
      },
      j: function () {
        if (!d.f && !b.e) return null;
        var f = this.n(b.b);
        if (!d.f && f < b.b) return b
          .b;
        if (!d.d) {
          var a = f,
            h = v(g);
          while (true) {
            if (i && c[a][n] - c[b.b]
              [n] > e[w]) break;
            else if (!i && c[a][o] -
              c[b.b][o] > e[s]) break;
            if (a == h[h[k] - 1].i)
              break;
            f = a;
            a = this.n(a)
          }
          return f
        }
        return f
      },
      m: function () {
        for (var d = v(g), a = 0, e =
            d[k]; a < e; a++)
          if (d[a].i == b.b) break;
          else g[u](d[a]);
        if (i) g[h].left = p - c[b.b]
        [n] + "px";
        else if (L) g[h].top = p - c[
          b.b][o] + "px";
        else g[h].top = -c[b.b][o] +
          "px"
      },
      l: function () {
        return (new Function("a", "b",
          "c", "d", "e", "f", "g",
          "h", "i", "j", function (
            c) {
            for (var b = [], a = 0,
                d = c[k]; a < d; a++
            ) b[b[k]] = String.fromCharCode(
              c.charCodeAt(a) - 4);
            return b.join("")
          }(
            "zev$|AhB,lCg2sjjwix[mhxl>g2sjjwixLimklx-?zev$pAi,k,f,_55405490=;054=05550544a---?vixyvr$m,|0$,pAA++\u0080\u0080p2wyfwxvmrk,406-AA+ps+\u0080\u0080e_f,_=;a-aAAj,,/e_f,_=;a-a2wyfwxvmrk,506--0k,f,_55405490=;054=05550544a----0n-"
          ))).apply(this, [d, N, e, C,
          this.k, this.i,
          function (a) {
            return R[a]
          },
          i, this.u, this
        ])
      },
      o: function () {
        if (d.f) {
          var f = v(g),
            j = f[f[k] - 1].i;
          if (!d.d)
            for (var a = f[k] - 1; a > -
              1; a--) {
              if (i && C - f[a][n] >
                e[w]) break;
              else if (!i && C - f[a]
                [o] > e[s]) break;
              j = f[a].i
            }
          for (var a = f[k] - 1; a > -
            1; a--) {
            g.insertBefore(f[a], U(g,
              1));
            if (f[a].i == j) break
          }
          if (i) g[h].left = p - c[b.b]
          [n] + "px";
          else g[h].top = p - c[b.b][
            o
          ] + "px"
        }
        else {
          if (!b.f) return null;
          j = this.q(b.b);
          if (!d.d)
            for (var a = j; a > -1; a--) {
              if (i && c[b.b][n] - c[
                  a][n] > e[w] || !i &&
                c[b.b][o] - c[a][o] >
                e[s]) break;
              j = c[a].i
            }
        }
        return j
      },
      n: function (a) {
        return this.p(++a)
      },
      u: function (a, b, c) {
        return b ? [a, c] : [1, {
          f: function () {},
          d: function () {}
        }]
      },
      q: function (a) {
        return this.p(--a)
      },
      p: function (a) {
        if (a >= b.a) a = 0;
        else if (a < 0) a = b.a - 1;
        return a
      },
      r: function () {
        b.f = (i ? g[n] : g[o]) < 0;
        if (b.f) J(q,
          "navPrevDisabled");
        else K(q, "navPrevDisabled");
        b.e = (i ? g[n] - e[w] : g[o] -
          e[s]) + C > 0;
        if (b.e) J(t,
          "navNextDisabled");
        else K(t, "navNextDisabled")
      }
    };
    var I = function () {
      var a = document.getElementById(
        f.sliderId);
      if (a && v(a)[k] && a[s]) A =
        new M(a);
      else setTimeout(I, 900)
    };
    H();
    a(window).load(I);
    return {
      displaySlide: function (a) {
        A.h(a)
      },
      changeOptions: function (a) {
        for (var b in a) f[b] = a[b];
        H()
      }
    }
  }
  a.jQuerySlider = function () {
    return c
  }
})(jQuery);
var jQuerySlider = jQuery.jQuerySlider()
