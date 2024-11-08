import * as THREE from "../../vendor/three/three.module.js"
import { OrbitControls } from "../../vendor/three/OrbitControls.js"
// window.THREE = THREE

const ThreeHook = {
    mounted(){

        
    // For example:
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    camera.position.set(3, 5, 6)
    const controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)

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
  light.position.set(3, 5, 6);
  scene.add(light);
  //Ambient Light
  const ambientLight = new THREE.AmbientLight(color, 5);
  scene.add(ambientLight);
  //---
  
  //Colors
  const player1color = 0xd4af37 
  const player2color = 0xc7d1da
  const player3color = 0xb87333
  const player4color = 0x00d062
  const player5color = 0xe0115f
  const player6color = 0x0f52ba
  const player7color = 0xffffff
  const player8color = 0x000000
  const highlightColor = 0x00ff00
  const cursorColor = 0x0000ff
  const captureColor = 0xff0000

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
                //columns and levels switched
                line.position.set(i,k,j)
                gridGroup.add(line);
          }
        }
      }
      gridGroup.visible = true;
      scene.add(gridGroup)
    }
  
   //Event listeners from LiveView
   this.handleEvent("setup_game", (payload) => {
    const dimensions = payload.board_dimensions
    const columns = dimensions.columns 
    const rows = dimensions.rows
    const levels = dimensions.levels
    render3Dgrid(columns, rows, levels)
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

    const animate = function () {
      requestAnimationFrame(animate);
      renderer.render(scene, camera);
    };

    animate(); 
    }
}

export default ThreeHook

