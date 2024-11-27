import * as THREE from "../../vendor/three/three.module.js"
import { OrbitControls } from "../../vendor/three/OrbitControls.js"
//needed for eval
window.THREE = THREE

const ThreeHook = {
    mounted(){

        
    // For example:
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();

    //set camera around z axis
    camera.up.set( 0, 0, 1 );
    //default pz_py
    camera.position.set(3, -3, 3)
    // pz_nx
    // camera.position.set(9, 3, 3)
    
    const controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    // camera.up.set( 0, 0, -1 );
    camera.lookAt(3, 3, 3)

    renderer.setSize(window.innerWidth /2 , window.innerHeight/ 2);
    this.el.appendChild(renderer.domElement);
    renderer.setClearColor(0x000000, 0)

    const geometry = new THREE.BoxGeometry();
    const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });

    //Window resizing
    window.addEventListener( 'resize', onWindowResize, false );

function onWindowResize(){
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize( window.innerWidth * .85, window.innerHeight );
}
  //Lights
  const color = 0xFFFFFF;
  const intensity = 10;
  const light = new THREE.DirectionalLight(color, intensity);
  light.position.set(3,-5, 6);
  scene.add(light);
  //Ambient Light
  const ambientLight = new THREE.AmbientLight(color, 5);
  scene.add(ambientLight);
  //---
  
  function changeCameraPosition(){

  }

  //rendering functions
  function clearScene(){
    scene.clear()
  }

  function render3Dgrid(rows, columns, levels){
    const gridGroup = new THREE.Group()
    gridGroup.name = 'gridGroup'
    //generate 3D arr
    for (let i = 0; i < rows; i++) {
        for (let j = 0; j < columns; j++) {
          for (let k = 0; k < levels; k++){
                const boxGeo = new THREE.BoxGeometry(1, 1, 1),
                edgeGeo = new THREE.EdgesGeometry(boxGeo),
                line = new THREE.LineSegments(
                    edgeGeo,
                    new THREE.LineBasicMaterial({
                        color: new THREE.Color('white')
                    }));
                line.position.set(i + 1, k + 1, j + 1)
                gridGroup.add(line);
          }
        }
      }
      gridGroup.visible = true;
      scene.add(gridGroup)
    }

  function renderBoard(board){
      console.log("HELLO")
  }
  
   //Event listeners from LiveView
   this.handleEvent("setup_game", (payload) => {
    const dimensions = payload.board_dimensions
    const columns = dimensions.columns 
    const rows = dimensions.rows
    const levels = dimensions.levels
    render3Dgrid(columns, rows, levels)
    const pieces = payload.pieces
    for (const [piece, info] of Object.entries(pieces)) {
      // const shape = "BoxGeometry(0.5, 0.5, 0.5)"
      // const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5)
      const geometry = eval(`new THREE.${info.model}`)
      const material = new THREE.MeshStandardMaterial( { color: info.color, roughness: 0.377, metalness: 1} )
      const obj = new THREE.Mesh( geometry, material );

      scene.add(obj)
      const [x, y, z] = info.coords
      obj.position.set(x, y, z)
      obj.name = piece
    }
    
   })

   this.handleEvent("toggle_grid", (payload) => {
          const gridGroup = scene.getObjectByName("gridGroup")
          if (gridGroup.visible){
              gridGroup.visible = false
          } else {
              gridGroup.visible = true
          }
          console.log("Yes Toggle", payload)
    })

    this.handleEvent("update_game", (payload) => {
      console.log(payload, "PAYLOAD")
      // renderBoard(payload)
})



  //---ANIMATE
    const animate = function () {
      requestAnimationFrame(animate);
      renderer.render(scene, camera);
    };

    animate(); 
    }
}

export default ThreeHook

