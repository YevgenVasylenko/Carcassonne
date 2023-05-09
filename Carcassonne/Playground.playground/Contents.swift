enum TileSides {
    case upSide
    case rightSide
    case downSide
    case leftSide
    case center
}

struct Tile {
    var upSide = TileSides.upSide
    var rightSide = TileSides.rightSide
    var downSide = TileSides.downSide
    var leftSide = TileSides.leftSide
    var centerSide = TileSides.center
    var sides: TileSides
}


//extension TileSides {
//    init(upSide: LandType, rightSide: LandType, downSide: LandType, leftSide: LandType, center: LandType) {
//        switch self {
//        case .upSide:
//            upSide
//        case .rightSide:
//            center
//        case .downSide:
//            downSide
//        case .leftSide:
//            leftSide
//        case .center:
//            center
//        }
//    }
//}
