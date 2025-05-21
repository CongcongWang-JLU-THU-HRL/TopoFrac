# **What is this repository for?**
TopoFrac is a software for identifying, extracting, and establishing the topological structure of natural fracture networks from trace images,
evaluating their topological complexity and predict equivalent permeability from the perspective of graph theory and complex networks.

# **How do I get set up?**
TopoFrac is developed in MATLAB and features a graphical user interface built using MATLAB App Designer. 
Copy the repository folder (Downloads from the menu on the above of this page). 

# **Usage**
(1) Users can use TopoFrac through two methods: either by double-clicking the standalone executable file within the installation directory, 
or by incorporating the TopoFrac directory into the MATLAB workspace path and running 'TopoFrac' in the MATLAB command window as a MATLAB function. 
Both methods invoke TopoFrac's graphical user interface, which features six modules:
  - Input
  - Characterization
  - Properties analysis
  - Equivalent permeability
  - Visualization
  - Output

(2) Click the 'Select' button in the input module and upload the trace image to be analysed. Once the image is loaded, it appears in the Visualization module. 

(3) Click the 'Construct Graph G' button in the Characterization module. Following successful execution of the characterization algorithm, 
the Characterization module automatically updates the quantitative network parameters, including the number of nodes (N), edges (M), connected components (Ncc), 
and the proportional distribution of nodes within each connected component of graph G. Meanwhile, the Visualization module adds four plots: 
  - a chart indicating the lengths and directions of fracture branches;
  - a spatial representation of the four classified node types superimposed on connected components differentiated by chromatic coding;
  - a topological visualization of graph G arranged according to the selected layout style, where node size is proportional to closeness centrality, while node color reflects their respective betweenness centrality values;
  - a histogram of nodes’ closeness and betweenness centrality.

(4) The Properties Analysis module incorporates three buttons, each dedicated to a distinct analytical operation within the fracture network characterization framework.
  - Upon clicking the "Calculate the degree distribution of G" button, the proportion of the four node types is displayed in the right table and visualized as a pie chart titled ‘Degree distribution’ in the "Visualization" module. 
  - Upon clicking the "Calculate the edge type in G" button, the distribution of the ten edge types is presented numerically in the adjacent table and graphically as a pie chart labeled 'Edge distribution' in the "Visualization" module. 
    Additionally, a table displaying the proportions of assortative and disassortative edges and a ternary diagram illustrating the proportions of I-I, I-C, and C-C edges are generated.
  - For other topological measures, users can select the ones they are interested in to calculate. 
    Among the properties, Pearson correlation coefficient r, clustering coefficient C, and efficiency E are determined by running custom functions in MATLAB, 
    while the diameter D, structural modularity Q, square clustering coefficient Cs, and small-world coefficient σ and ω are computed by executing Python scripts from within the MATLAB environment. 
    Therefore, calculation of the five measures requires a MATLAB-compatible Python installation on the user's system. 
    For compatibility information, users should refer to the “Versions of Python Compatible with MATLAB Products by Release - MATLAB & Simulink” document. 
    Furthermore, the Python installation path must be added to both system environment variables and MATLAB's search path, which can be configured using the pyenv command within MATLAB. 

(5) Equivalent permeability module calculates the hydraulic connectivity parameter f and predicts the equivalent permeability tensor. Firstly, the usuer should click the 'Calculate the hydraulic connectivity f' button, 
then set up the fracture length-aperture relationship and scale of the image, and calculate the equivalent permeability finally.

(6) Upon completion of the calculation, the main variables could be exported to a MAT file and an excel file by clicking the 'save' button in the Output module. 

# **Who do I talk to?**
Congcong Wang, Beijing Huairou Laboratory
wangcongcong060712@163.com
