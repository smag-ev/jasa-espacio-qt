import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: mat12_material
        objectName: "mat12"
        baseColor: "#ffc3a843"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat13_material
        objectName: "mat13"
        baseColor: "#ff666768"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat14_material
        objectName: "mat14"
        baseColor: "#ff474747"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat15_material
        objectName: "mat15"
        baseColor: "#ff1d1d1d"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat16_material
        objectName: "mat16"
        baseColor: "#ff4e4e4e"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat17_material
        objectName: "mat17"
        baseColor: "#ff8c8c8c"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat18_material
        objectName: "mat18"
        baseColor: "#ff2d3e98"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat19_material
        objectName: "mat19"
        baseColor: "#ffd3d3cd"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat20_material
        objectName: "mat20"
        baseColor: "#ffb1b2ad"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat21_material
        objectName: "mat21"
        baseColor: "#ffc88c28"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat22_material
        objectName: "mat22"
        baseColor: "#ffc88c28"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat23_material
        objectName: "mat23"
        baseColor: "#ff262313"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat24_material
        objectName: "mat24"
        baseColor: "#ff261b1f"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat25_material
        objectName: "mat25"
        baseColor: "#ff16141a"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat26_material
        objectName: "mat26"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat0_material
        objectName: "mat0"
        baseColor: "#ff333333"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat1_material
        objectName: "mat1"
        baseColor: "#ffc8c8c8"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat2_material
        objectName: "mat2"
        baseColor: "#ff1f1f1f"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat3_material
        objectName: "mat3"
        baseColor: "#ff75506c"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat4_material
        objectName: "mat4"
        baseColor: "#ff76516d"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat5_material
        objectName: "mat5"
        baseColor: "#ffa6a6a6"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat6_material
        objectName: "mat6"
        baseColor: "#ff2b2b2b"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat7_material
        objectName: "mat7"
        baseColor: "#ff767676"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat8_material
        objectName: "mat8"
        baseColor: "#ffc6bd92"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat9_material
        objectName: "mat9"
        baseColor: "#ffb6b6b6"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat10_material
        objectName: "mat10"
        baseColor: "#ff75506c"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: mat11_material
        objectName: "mat11"
        baseColor: "#ffc88c28"
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: jwst_obj
        objectName: "jwst.obj"
        Model {
            id: obj1
            objectName: "obj1"
            source: "jwst/obj1_mesh.mesh"
            materials: [
                mat0_material
            ]
        }
        Model {
            id: obj2
            objectName: "obj2"
            source: "jwst/obj2_mesh.mesh"
            materials: [
                mat1_material
            ]
        }
        Model {
            id: obj3
            objectName: "obj3"
            source: "jwst/obj3_mesh.mesh"
            materials: [
                mat2_material
            ]
        }
        Model {
            id: obj4
            objectName: "obj4"
            source: "jwst/obj4_mesh.mesh"
            materials: [
                mat2_material
            ]
        }
        Model {
            id: obj5
            objectName: "obj5"
            source: "jwst/obj5_mesh.mesh"
            materials: [
                mat3_material
            ]
        }
        Model {
            id: obj6
            objectName: "obj6"
            source: "jwst/obj6_mesh.mesh"
            materials: [
                mat4_material
            ]
        }
        Model {
            id: obj7
            objectName: "obj7"
            source: "jwst/obj7_mesh.mesh"
            materials: [
                mat3_material
            ]
        }
        Model {
            id: obj8
            objectName: "obj8"
            source: "jwst/obj8_mesh.mesh"
            materials: [
                mat5_material
            ]
        }
        Model {
            id: obj9
            objectName: "obj9"
            source: "jwst/obj9_mesh.mesh"
            materials: [
                mat6_material
            ]
        }
        Model {
            id: obj10
            objectName: "obj10"
            source: "jwst/obj10_mesh.mesh"
            materials: [
                mat7_material
            ]
        }
        Model {
            id: obj11
            objectName: "obj11"
            source: "jwst/obj11_mesh.mesh"
            materials: [
                mat7_material
            ]
        }
        Model {
            id: obj12
            objectName: "obj12"
            source: "jwst/obj12_mesh.mesh"
            materials: [
                mat8_material
            ]
        }
        Model {
            id: obj13
            objectName: "obj13"
            source: "jwst/obj13_mesh.mesh"
            materials: [
                mat4_material
            ]
        }
        Model {
            id: obj14
            objectName: "obj14"
            source: "jwst/obj14_mesh.mesh"
            materials: [
                mat9_material
            ]
        }
        Model {
            id: obj15
            objectName: "obj15"
            source: "jwst/obj15_mesh.mesh"
            materials: [
                mat9_material
            ]
        }
        Model {
            id: obj16
            objectName: "obj16"
            source: "jwst/obj16_mesh.mesh"
            materials: [
                mat9_material
            ]
        }
        Model {
            id: obj17
            objectName: "obj17"
            source: "jwst/obj17_mesh.mesh"
            materials: [
                mat9_material
            ]
        }
        Model {
            id: obj18
            objectName: "obj18"
            source: "jwst/obj18_mesh.mesh"
            materials: [
                mat10_material
            ]
        }
        Model {
            id: obj19
            objectName: "obj19"
            source: "jwst/obj19_mesh.mesh"
            materials: [
                mat11_material
            ]
        }
        Model {
            id: obj20
            objectName: "obj20"
            source: "jwst/obj20_mesh.mesh"
            materials: [
                mat12_material
            ]
        }
        Model {
            id: obj21
            objectName: "obj21"
            source: "jwst/obj21_mesh.mesh"
            materials: [
                mat13_material
            ]
        }
        Model {
            id: obj22
            objectName: "obj22"
            source: "jwst/obj22_mesh.mesh"
            materials: [
                mat14_material
            ]
        }
        Model {
            id: obj23
            objectName: "obj23"
            source: "jwst/obj23_mesh.mesh"
            materials: [
                mat15_material
            ]
        }
        Model {
            id: obj24
            objectName: "obj24"
            source: "jwst/obj24_mesh.mesh"
            materials: [
                mat16_material
            ]
        }
        Model {
            id: obj25
            objectName: "obj25"
            source: "jwst/obj25_mesh.mesh"
            materials: [
                mat17_material
            ]
        }
        Model {
            id: obj26
            objectName: "obj26"
            source: "jwst/obj26_mesh.mesh"
            materials: [
                mat18_material
            ]
        }
        Model {
            id: obj27
            objectName: "obj27"
            source: "jwst/obj27_mesh.mesh"
            materials: [
                mat19_material
            ]
        }
        Model {
            id: obj28
            objectName: "obj28"
            source: "jwst/obj28_mesh.mesh"
            materials: [
                mat19_material
            ]
        }
        Model {
            id: obj29
            objectName: "obj29"
            source: "jwst/obj29_mesh.mesh"
            materials: [
                mat20_material
            ]
        }
        Model {
            id: obj30
            objectName: "obj30"
            source: "jwst/obj30_mesh.mesh"
            materials: [
                mat21_material
            ]
        }
        Model {
            id: obj31
            objectName: "obj31"
            source: "jwst/obj31_mesh.mesh"
            materials: [
                mat22_material
            ]
        }
        Model {
            id: obj32
            objectName: "obj32"
            source: "jwst/obj32_mesh.mesh"
            materials: [
                mat23_material
            ]
        }
        Model {
            id: obj33
            objectName: "obj33"
            source: "jwst/obj33_mesh.mesh"
            materials: [
                mat24_material
            ]
        }
        Model {
            id: obj34
            objectName: "obj34"
            source: "jwst/obj34_mesh.mesh"
            materials: [
                mat24_material
            ]
        }
        Model {
            id: obj35
            objectName: "obj35"
            source: "jwst/obj35_mesh.mesh"
            materials: [
                mat25_material
            ]
        }
        Model {
            id: obj36
            objectName: "obj36"
            source: "jwst/obj36_mesh.mesh"
            materials: [
                mat26_material
            ]
        }
    }
}
