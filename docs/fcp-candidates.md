# FCP Server Candidates

Potential FCP server implementations, organized by value tier. The sweet spot is formats where the LLM knows what it wants but can't reliably produce the bytes.

Three criteria: (1) format complexity that defeats raw LLM output, (2) clean mapping to verb grammar, (3) genuine user demand.

## Completed

| Server | Package | Category | Description |
|--------|---------|----------|-------------|
| fcp-drawio | @os-tack/fcp-drawio | development | draw.io diagram creation/editing |
| fcp-terraform | github.com/os-tack/fcp-terraform | devops | Terraform HCL generation (Go) |
| fcp-midi | fcp-midi | creative | Semantic MIDI composition |
| fcp-sheets | fcp-sheets | documents | Semantic spreadsheet creation/editing |
| fcp-slides | fcp-slides | documents | Semantic PowerPoint presentation creation |

## Tier 1 — High Value, Natural Fit

### SVG (fcp-svg)

- **Category:** creative
- **Format:** SVG XML
- **Why:** LLMs routinely produce broken SVGs — unclosed paths, wrong viewBox math, overlapping elements. SVGs are the universal output format for web/docs/presentations.
- **Semantic model:** Tree of Shapes (rect, circle, path), Groups, Gradients, Filters with position, size, fill properties
- **Example ops:**
  - `add rect id:background size:100%x100% fill:#f0f0f0`
  - `add circle center:50,50 r:30 fill:blue`
  - `add path id:wave data:"M0,50 C100,0 150,100 250,50" stroke:blue stroke-width:3`
  - `add text "Hello" at:100,50 size:14`
  - `group background,wave as:Header`
- **Status:** Draft spec exists (`fcp-core/docs/drafts/fcp-svg-spec-draft.md`)

## Tier 2 — Specialized but High Impact

### PlantUML / Mermaid (fcp-uml)

- **Category:** development
- **Format:** PlantUML / Mermaid text
- **Why:** Text-based but LLMs still mess up the syntax regularly, especially for sequence diagrams and state machines. FCP could provide a unified interface that targets multiple diagram backends.
- **Semantic model:** Diagram types with Actors, Classes, States, Transitions, Messages
- **Example ops:**
  - `sequence Alice -> Bob message:"hello"`
  - `class User { id:uuid name:string email:string }`
  - `state Idle -> Running trigger:start`

### OpenAPI / Swagger (fcp-openapi)

- **Category:** development
- **Format:** OpenAPI 3.x YAML/JSON
- **Why:** API spec generation is common but getting valid OpenAPI 3.1 with correct $ref chains, proper schema composition, and consistent naming is hard for LLMs.
- **Semantic model:** API with Paths, Operations, Schemas, Security, Servers
- **Example ops:**
  - `endpoint GET /users response:200 schema:UserList`
  - `schema User { id:uuid name:string email:string }`
  - `security bearer scope:read:users`

### PDF Generation (fcp-pdf)

- **Category:** documents
- **Format:** PDF
- **Why:** Not PDF reading (solved problem) but PDF generation. Direct PDF construction is byte-level pain.
- **Semantic model:** Document with Pages, Text blocks, Images, Tables, Headers/Footers
- **Example ops:**
  - `page A4 margin:1in`
  - `heading "Quarterly Report"`
  - `table data:csv columns:4`
  - `image path:"chart.png" width:50%`

### Docker Compose / K8s Manifests (fcp-containers)

- **Category:** devops
- **Format:** Docker Compose YAML, Kubernetes YAML
- **Why:** YAML indentation aside, the real problem is getting service dependencies, volume mounts, network configs, and health checks right.
- **Semantic model:** Services, Volumes, Networks, Deployments, ConfigMaps
- **Example ops:**
  - `service api image:node:22 port:3000:3000 depends:db`
  - `service db image:postgres:16 volume:pgdata:/var/lib/postgresql/data env:POSTGRES_PASSWORD=secret`
  - `deploy api replicas:3 strategy:rolling`
- **Status:** Draft spec exists (`fcp-core/docs/drafts/fcp-k8s-draft.md`)

### LaTeX (fcp-latex)

- **Category:** documents
- **Format:** LaTeX .tex
- **Why:** Academic users constantly ask for LaTeX. The syntax is brutal for LLMs to get right consistently.
- **Semantic model:** Document with Sections, Equations, Figures, Tables, Bibliography
- **Example ops:**
  - `document article`
  - `section "Introduction"`
  - `equation "E = mc^2" label:eq1`
  - `cite author:Einstein year:1905`
  - `figure path:diagram.png caption:"System overview"`

### 3D Modeling (fcp-3d)

- **Category:** creative
- **Format:** glTF / USD
- **Why:** Incredibly complex formats involving JSON scene graphs, binary buffers for geometry, and intricate definitions for materials, animations, and skeletons. Virtually impossible for an LLM to write directly.
- **Semantic model:** Scene with Nodes (transforms), Meshes (vertices, faces), Materials (PBR), Animations, Cameras
- **Example ops:**
  - `add mesh id:floor from:plane size:100x100 material:concrete`
  - `add mesh id:character from:./char.glb at:0,0,0`
  - `add-animation character property:position keys:"0s:(0,0,0); 5s:(0,10,0)"`
  - `point camera at:character`

## Tier 3 — Niche / Exploratory

| Candidate | Category | Format | Example Op | Notes |
|-----------|----------|--------|------------|-------|
| CAD/STL | creative | STL/STEP | `cube 10x10x10 at:origin, fillet edge:top r:2` | 3D printing, parametric geometry |
| BPMN | development | BPMN XML | `task "Review" actor:Manager, gateway exclusive` | Business process modeling |
| GraphViz/DOT | development | DOT | `node A label:"Start", edge A -> B` | Simpler than draw.io but still error-prone |
| iCalendar/ICS | documents | ICS | `event "Standup" at:9am recur:weekdays dur:15m` | Calendar event generation |
| GeoJSON | development | GeoJSON | `point "Office" lat:30.26 lon:-97.74` | Map data, coordinate precision |

## Category Taxonomy

| Category | Convention | Servers |
|----------|-----------|---------|
| development | Dev tooling formats | fcp-drawio, fcp-openapi, fcp-uml |
| devops | Infrastructure formats | fcp-terraform, fcp-containers |
| creative | Media/art formats | fcp-midi, fcp-svg, fcp-3d |
| documents | Office/document formats | fcp-sheets, fcp-slides, fcp-pdf, fcp-latex |
