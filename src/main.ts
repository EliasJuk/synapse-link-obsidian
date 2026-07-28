import { Notice, Plugin } from "obsidian";

export default class SynapseLinkPlugin extends Plugin {

  async onload() {
    console.log("SynapseLink iniciado");

    this.addCommand({
      id: "teste-synapse",
      name: "Teste SynapseLink",
      callback: () => {
        new Notice("SynapseLink funcionando!");
      }
    });
  }

  onunload() {
    console.log("SynapseLink finalizado");
  }
}