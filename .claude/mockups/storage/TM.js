.pragma library
// Squarified treemap (Bruls, Huizing, van Wijk 2000). items: [{bytes,...}] -> [{x,y,w,h,item}]
function worst(row, side) {
  var s=0, mx=0, mn=Infinity
  for (var i=0;i<row.length;i++){ s+=row[i].a; mx=Math.max(mx,row[i].a); mn=Math.min(mn,row[i].a) }
  return Math.max(side*side*mx/(s*s), (s*s)/(side*side*mn))
}
function layout(items, x, y, w, h) {
  var out=[], tot=0
  var its=items.filter(function(i){return i.bytes>0}).sort(function(a,b){return b.bytes-a.bytes})
  for (var i=0;i<its.length;i++) tot+=its[i].bytes
  if (tot<=0||w<=0||h<=0) return out
  var vals=its.map(function(i){return {item:i, a:i.bytes*w*h/tot}})
  var row=[]
  function place() {
    var s=0; for (var k=0;k<row.length;k++) s+=row[k].a
    if (w>=h) { var cw=s/h, yy=y
      for (k=0;k<row.length;k++){ var rh=row[k].a/cw; out.push({x:x,y:yy,w:cw,h:rh,item:row[k].item}); yy+=rh }
      x+=cw; w-=cw
    } else { var rh2=s/w, xx=x
      for (k=0;k<row.length;k++){ var rw=row[k].a/rh2; out.push({x:xx,y:y,w:rw,h:rh2,item:row[k].item}); xx+=rw }
      y+=rh2; h-=rh2 }
    row=[]
  }
  while (vals.length) {
    var side=Math.min(w,h)
    if (row.length===0 || worst(row.concat([vals[0]]),side) <= worst(row,side)) row.push(vals.shift())
    else place()
  }
  if (row.length) place()
  return out
}
