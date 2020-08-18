import 'dart:ui';
import 'package:scribbl/pages/Painter_screen/painter/painterData.dart';

import '../../room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  PainterData painterData;
  CRUD({this.painterData});
  Future<void> updateStroke() async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(documentid)
        .update({
      'xpos': painterData.listX,
      'ypos': painterData.listY,
      'length': painterData.tempInd,
      'indices': painterData.indices,
      'colorIndexStack': painterData.colorIndexStack,
      'pointer': painterData.p
    });
  }

  Future<void> updatePointer() async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(documentid)
        .update({'pointer': painterData.p});
  }
}

// void tapFunction(TapUpDetails details) {
//   print('point drawn');
//   setState(() {
//     RenderBox obj = context.findRenderObject();
//     Offset _localP = obj.globalToLocal(details.globalPosition);
//     if (indices[p] != tempInd) {
//       listX = truncate3(listX, indices[p]);
//       listY = truncate3(listY, indices[p]);
//       pointsD = truncate2(pointsD, indices[p]);
//       indices = truncate(indices, p);
//     }
//     pointsD.add(Offset(-1.0, -1.0));
//     listY.add(-1.0);
//     listX.add(-1.0);
//     tempInd = indices[p] + 1;
//     pointsD = new List.from(pointsD)..add(_localP);
//     listY.add(_localP.dy);
//     listX.add(_localP.dx);
//     tempInd++;
//     pointsD.add(null);
//     listY.add(null);
//     listX.add(null);
//     tempInd++;
//     indices.add(tempInd);
//     p = p + 1;
//     indices[p] = tempInd;
//     updateStroke();
//   });
// }
class StringOperations {
  List truncate(List a, ind) {
    List<int> modified = new List();
    for (int i = 0; i <= ind; i++) {
      modified.add(a[i]);
    }
    return modified;
  }

  List truncate2(List a, ind) {
    List<Offset> modified = new List();
    for (int i = 0; i <= ind; i++) {
      modified.add(a[i]);
    }
    return modified;
  }

  List truncate3(List a, ind) {
    List<double> modified = new List();
    for (int i = 0; i <= ind; i++) {
      modified.add(a[i]);
    }
    return modified;
  }
}
